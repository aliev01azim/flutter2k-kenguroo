import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenguroo/providers/food_categories.dart';
import 'package:provider/provider.dart';

class AddingFoodScreen extends StatefulWidget {
  static const routeName = '/adding-food-screen';

  @override
  _AddingFoodScreenState createState() => _AddingFoodScreenState();
}

class _AddingFoodScreenState extends State<AddingFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timeFocus = FocusNode();
  final _discountFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  var _initialValue = {
    'title': '',
    'time': '',
    'discount': '',
    'imageUrl': '',
  };
  var _editedFood =
      FoodModel(id: null, time: '', title: '', imageUrl: '', discount: 0);
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImageUrl);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     final foodId = ModalRoute.of(context).settings.arguments as String;
  //     if (foodId != null) {
  //       _editedFood = Provider.of<FoodCategories>(context, listen: false)
  //           .findById(foodId);
  //       _initialValue = {
  //         'title': _editedFood.title,
  //         'time': _editedFood.time,
  //         'discount': _editedFood.discount.toString(),
  //         'imageUrl': '',
  //       };
  //       _imageUrlController.text = _editedFood.imageUrl;
  //     }
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  void dispose() {
    _imageUrlFocus.removeListener(_updateImageUrl);
    _timeFocus.dispose();
    _discountFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocus.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  bool _isLoadingImage = false;
  String imageUrl;
  PickedFile _image;
  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    //Select Image
    _image = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    var file = File(_image.path);

    if (_image != null) {
      setState(() {
        _isLoadingImage = true;
      });
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child('images/${Path.basename(_image.path)}}')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        _editedFood.imageUrl = downloadUrl;
      });
      print(_editedFood.imageUrl);
    }
    setState(() {
      _isLoadingImage = false;
    });
  }

  Future<void> _saveForm() async {
    // final isValid = _formKey.currentState.validate();
    // if (!isValid) {
    //   return;
    // }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    _editedFood.imageUrl = imageUrl;
    if (_editedFood.id != null) {
      await Provider.of<FoodCategories>(context, listen: false)
          .updateFood(_editedFood.id, _editedFood);
    } else {
      try {
        await Provider.of<FoodCategories>(context, listen: false)
            .addFood(_editedFood);
      } on PlatformException catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text(error.message),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final String cafeid = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Добавьте еду',
          style: TextStyle(color: Colors.black),
        )),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          initialValue: _initialValue['title'],
                          decoration: InputDecoration(
                              labelText: 'title', hintText: 'Беш Бармак'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_timeFocus);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your title';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _editedFood = FoodModel(
                                cafeId: cafeid,
                                id: _editedFood.id,
                                isFavorite: _editedFood.isFavorite,
                                time: _editedFood.time,
                                title: val,
                                imageUrl: _editedFood.imageUrl,
                                discount: _editedFood.discount);
                          },
                        ),
                        TextFormField(
                          maxLines: 3,
                          decoration: InputDecoration(
                              labelText: 'Описание',
                              hintText: 'Опишите еду,ингридиенты тд и тп'),
                          validator: (value) {
                            if (value.length < 10) {
                              return 'Please enter at least 10 characters.';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.newline,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_discountFocus);
                          },
                          focusNode: _timeFocus,
                          onSaved: (newValue) {
                            _editedFood = FoodModel(
                                cafeId: cafeid,
                                id: _editedFood.id,
                                time: newValue,
                                isFavorite: _editedFood.isFavorite,
                                title: _editedFood.title,
                                imageUrl: _editedFood.imageUrl,
                                discount: _editedFood.discount);
                          },
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_imageUrlFocus);
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'price', hintText: '300'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your last time.';
                            }
                            return null;
                          },
                          focusNode: _discountFocus,
                          onSaved: (newValue) {
                            _editedFood = FoodModel(
                                cafeId: cafeid,
                                id: _editedFood.id,
                                time: _editedFood.time,
                                isFavorite: _editedFood.isFavorite,
                                title: _editedFood.title,
                                imageUrl: _editedFood.imageUrl,
                                discount: int.parse(newValue));
                          },
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(
                                top: 8,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: _isLoadingImage
                                  ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    )
                                  : _imageUrlController.text.isEmpty &&
                                          imageUrl == null
                                      ? Center(
                                          child: Text(
                                          'no image taken yet',
                                          textAlign: TextAlign.center,
                                        ))
                                      : FittedBox(
                                          child: _imageUrlController
                                                      .text.isNotEmpty &&
                                                  imageUrl == null
                                              ? Image.network(
                                                  _imageUrlController.text,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                )),
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              focusNode: _imageUrlFocus,
                              enabled: _image != null ? false : true,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL.';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image URL.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSaved: (value) {
                                _editedFood = FoodModel(
                                  cafeId: cafeid,
                                  title: _editedFood.title,
                                  imageUrl: value,
                                  id: _editedFood.id,
                                  isFavorite: _editedFood.isFavorite,
                                  time: _editedFood.time,
                                  discount: _editedFood.discount,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton.icon(
                          onPressed: _imageUrlController.text.isNotEmpty
                              ? null
                              : uploadImage,
                          icon: Icon(Icons.camera),
                          label: Text('Or choose from Gallery!'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: _saveForm,
                          child: Text('Завершить'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _saveForm();
                            Navigator.of(context).pushReplacementNamed(
                                AddingFoodScreen.routeName,
                                arguments: cafeid);
                          },
                          child: Text('Добавить еще'),
                        ),
                      ],
                    ),
                  ),
                )));
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:provider/provider.dart';

class AddingCafeScreen extends StatefulWidget {
  static const routeName = '/adding-cafe-screen';
  @override
  _AddingCafeScreenState createState() => _AddingCafeScreenState();
}

class _AddingCafeScreenState extends State<AddingCafeScreen> {
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
  var _editedCafe =
      CafeModel(id: null, time: 0, title: '', imageUrl: '', discount: 0);
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final cafeId = ModalRoute.of(context).settings.arguments as String;
      if (cafeId != null) {
        _editedCafe = Provider.of<CafeCategories>(context, listen: false)
            .findById(cafeId);
        _initialValue = {
          'title': _editedCafe.title,
          'time': _editedCafe.time.toString(),
          'discount': _editedCafe.discount.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedCafe.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedCafe.id != null) {
      await Provider.of<CafeCategories>(context, listen: false)
          .updateCafe(_editedCafe.id, _editedCafe);
    } else {
      try {
        await Provider.of<CafeCategories>(context, listen: false)
            .addCafe(_editedCafe);
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
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Зaполните форму',
          style: TextStyle(color: Colors.black),
        )),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          initialValue: _initialValue['title'],
                          decoration: InputDecoration(
                              labelText: 'title', hintText: 'Фаиза'),
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
                            _editedCafe = CafeModel(
                                id: _editedCafe.id,
                                isFavorite: _editedCafe.isFavorite,
                                time: _editedCafe.time,
                                title: val,
                                imageUrl: _editedCafe.imageUrl,
                                discount: _editedCafe.discount);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'how many minutes will it take',
                              hintText: '30'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your last time.';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_discountFocus);
                          },
                          focusNode: _timeFocus,
                          onSaved: (newValue) {
                            _editedCafe = CafeModel(
                                id: _editedCafe.id,
                                time: int.parse(newValue),
                                isFavorite: _editedCafe.isFavorite,
                                title: _editedCafe.title,
                                imageUrl: _editedCafe.imageUrl,
                                discount: _editedCafe.discount);
                          },
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_imageUrlFocus);
                          },
                          decoration: InputDecoration(
                              labelText: 'is there a promotion?',
                              hintText: '30'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your last time.';
                            }
                          },
                          focusNode: _discountFocus,
                          onSaved: (newValue) {
                            _editedCafe = CafeModel(
                                id: _editedCafe.id,
                                time: _editedCafe.time,
                                isFavorite: _editedCafe.isFavorite,
                                title: _editedCafe.title,
                                imageUrl: _editedCafe.imageUrl,
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
                              child: _imageUrlController.text.isEmpty &&
                                      _image == null
                                  ? Center(
                                      child: Text(
                                      'no image taken yet',
                                      textAlign: TextAlign.center,
                                    ))
                                  : FittedBox(
                                      child: _imageUrlController.text.isNotEmpty
                                          ? Image.network(
                                              _imageUrlController.text,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              _image,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
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
                              onSaved: (value) {
                                _editedCafe = CafeModel(
                                  title: _editedCafe.title,
                                  imageUrl: value,
                                  id: _editedCafe.id,
                                  isFavorite: _editedCafe.isFavorite,
                                  time: _editedCafe.time,
                                  discount: _editedCafe.discount,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton.icon(
                          onPressed: _imageUrlController.text.isEmpty
                              ? getImage
                              : null,
                          icon: Icon(Icons.camera),
                          label: Text('Or choose from Gallery!'),
                        ),
                      ])),
            )));
  }
}

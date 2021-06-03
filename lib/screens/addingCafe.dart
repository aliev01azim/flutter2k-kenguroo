import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:kenguroo/screens/addingFood.dart';
import 'package:kenguroo/widgets/kuhni.dart';
import 'package:kenguroo/widgets/kuhni_listtile.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

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
  var _editedCafe = CafeModel(time: 0, title: '', imageUrl: '', discount: 0);
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

  // work with images
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 60,
        maxWidth: double.infinity);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  String _uploadedFileURL;
  var _timer;
  // form
  Future<void> _saveForm() async {
    // print('saveForm');
    // final isValid = _formKey.currentState.validate();
    // if (!isValid) {
    //   print('da nuu');
    //   return;
    // }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    print(_image.path);
    if (_image.path != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference =
          storage.ref().child('images/${Path.basename(_image.path)}}');

      UploadTask uploadTask = storageReference.putFile(_image);
      await storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
          _editedCafe.imageUrl = _uploadedFileURL;
        });
        print('doljen peredast $_uploadedFileURL');
        print('posle peredachi ${_editedCafe.imageUrl}');
      });
      uploadTask.then((res) {
        res.ref.getDownloadURL();
      });
      print(
          'smotriiiiiiiiiismotriiiiiiiiiismotriiiiiiiiiismotriiiiiiiiiismotriiiiiiiiiismotriiiiiiiiii');
      print(_editedCafe.imageUrl);
      print('posle delaya $_uploadedFileURL');
    }
    print('posle vsego ${_editedCafe.imageUrl}');

    if (_editedCafe.id != null) {
      await Provider.of<CafeCategories>(context, listen: false)
          .updateCafe(_editedCafe.id, _editedCafe);
    } else {
      try {
        print('adding cafe');

        await Provider.of<CafeCategories>(context, listen: false)
            .addCafe(_editedCafe, chosenKuhni);
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
    print('imageUrl:');
    print(_editedCafe.imageUrl);
    setState(() {
      _isLoading = false;
    });
    final cafeid =
        Provider.of<CafeCategories>(context, listen: false).lastCafe.id;
    Navigator.of(context)
        .pushNamed(AddingFoodScreen.routeName, arguments: cafeid);
  }

  // kuhni
  List<String> chosenKuhni = [];
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void callBack(List<String> list) {
    setStateIfMounted(() {
      chosenKuhni = list;
    });
  }

  void onDisMissed(int id) {
    if (chosenKuhni.length > 0) {
      chosenKuhni.removeAt(id);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Зaполните форму',
          style: TextStyle(color: Colors.black),
        )),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
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
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
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
                                              File(_image.path),
                                              fit: BoxFit.cover,
                                            )),
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              focusNode: _imageUrlFocus,
                              enabled: _image != null ? false : true,
                              textInputAction: TextInputAction.next,
                              controller: _imageUrlController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image URL.';
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
                              onChanged: (value) {
                                setState(() {});
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
                              : getImage,
                          icon: Icon(Icons.camera,
                              color: _imageUrlController.text.isNotEmpty
                                  ? Colors.grey.shade400
                                  : const Color(0xFF167F67)),
                          label: Text(
                            'Or choose from Gallery!',
                            style: _imageUrlController.text.isNotEmpty
                                ? TextStyle(color: Colors.grey)
                                : TextStyle(color: const Color(0xFF167F67)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Kuhni(callBack),
                        if (chosenKuhni.isNotEmpty)
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: chosenKuhni.length,
                            itemBuilder: (context, index) => KuhniListTile(
                              chosenKuhni[index],
                              onDisMissed,
                              index,
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: _saveForm,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF167F67))),
                          child: Text('Submit!'),
                        ),
                      ],
                    ),
                  ),
                )));
  }
}

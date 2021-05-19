import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenguroo/models/user.dart';
import 'package:kenguroo/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = firebase.FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  bool isMale = false;
  bool isFemale = false;
  // calendar
  // DateTimePickerLocale _locale = DateTimePickerLocale.ru;
  // String _format = '';
  // DateTime _dateTime;

  // form
  var _initVals = {
    'name': '',
    'surname': '',
    /*'date': ''*/
    'email': '',
    'number': '',
    'userImage': '',
  };
  var _editedUser = User(
    name: '',
    surname: '',
    /*date: null*/
    email: '',
    userImage: '',
  );
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_editedUser == null) {
        await Provider.of<UserProvider>(context, listen: false)
            .addUser(_editedUser, isMale, _image.path, user.uid);
      } else {
        await Provider.of<UserProvider>(context, listen: false)
            .updateUser(_editedUser, isMale, _image.path, user.uid);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
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
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      getuser();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getuser() async {
    final us = await Provider.of<UserProvider>(context, listen: false)
        .getUser(user.uid);
    if (us != null) {
      _editedUser = User(
          name: us.name,
          surname: us.surname,
          email: us.email,
          isMale: us.isMale,
          userImage: us.userImage);
      _initVals = {
        'name': _editedUser.name,
        'surname': _editedUser.surname,
        /*'date': ''*/
        'email': _editedUser.email,
        'number': '',
        'userImage': _editedUser.userImage,
      };
      if (_editedUser.isMale == true) {
        isMale = true;
        isFemale = false;
      } else {
        isMale = false;
        isFemale = true;
      }
    }
  }
  // void _showDatePicker() {
  //   DatePicker.showDatePicker(
  //     context,
  //     minDateTime: DateTime(1930),
  //     maxDateTime: DateTime.now(),
  //     onMonthChangeStartWithFirstDate: true,
  //     pickerTheme: DateTimePickerTheme(
  //       showTitle: true,
  //       confirm: Text('Select', style: TextStyle(color: Colors.green)),
  //     ),
  //     initialDateTime: _dateTime,
  //     dateFormat: _format,
  //     locale: _locale,
  //     onChange: (dateTime, List<int> index) {
  //       setState(() {
  //         _dateTime = dateTime;
  //       });
  //     },
  //     onConfirm: (dateTime, List<int> index) {
  //       setState(() {
  //         _dateTime = dateTime;
  //       });
  //     },
  //   );
  // }

//  image
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        if (_initVals['userImage'].isNotEmpty) {
          _image = File(_initVals['userImage']);
        } else {
          _image = File(pickedFile.path);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No image selected'),
          action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Настройки Аккаунта"),
        actions: [IconButton(icon: Icon(Icons.done), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage('assets/images/user.jpg')
                                : FileImage(_image),
                          )),
                      height: 230,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: IconButton(
                              icon: Icon(
                                Icons.photo_camera,
                                color: Colors.grey.shade400,
                                size: 45,
                              ),
                              onPressed: getImage),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: TextFormField(
                        initialValue: _initVals['name'],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Ваше имя',
                        ),
                        onSaved: (value) {
                          _editedUser = User(
                            name: value,
                            surname: _editedUser.surname,
                            email: _editedUser.email,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: TextFormField(
                        initialValue: _initVals['surname'],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Ваша фамилия',
                        ),
                        onSaved: (value) {
                          _editedUser = User(
                            name: _editedUser.name,
                            surname: value,
                            email: _editedUser.email,
                          );
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 14.0),
                    //   child: TextFormField(
                    //     initialValue: _initVals['date'],
                    //     keyboardType: null,
                    //     decoration: InputDecoration(
                    //       hintText:
                    //           '${_dateTime.year.toString()}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}',
                    //       contentPadding: EdgeInsets.symmetric(vertical: 20),
                    //     ),
                    //     readOnly: true,
                    //     onTap: _showDatePicker,
                    //     onSaved: (value) {
                    //       print(_initVals['date']);
                    //       _editedUser = User(
                    //           name: _editedUser.name,
                    //           surname: _editedUser.surname,
                    //           date: DateFormat('yyyy-MM-dd').parse(value));
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade500, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isMale = !isMale;
                                isFemale = !isMale;
                              });
                            },
                            splashColor: Colors.transparent,
                            child: Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  margin: EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: isMale
                                        ? Colors.grey.shade700
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.grey.shade700,
                                        width: 1.5),
                                  ),
                                ),
                                Text(
                                  'Мужчина',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isMale = !isMale;
                                isFemale = !isMale;
                              });
                            },
                            splashColor: Colors.transparent,
                            child: Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  margin: EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: isFemale
                                        ? Colors.grey.shade700
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.grey.shade700,
                                        width: 1.5),
                                  ),
                                ),
                                Text(
                                  'Женщина',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: TextFormField(
                        initialValue: _initVals['email'],
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Ваш email',
                        ),
                        onSaved: (value) {
                          _editedUser = User(
                              name: _editedUser.name,
                              surname: _editedUser.surname,
                              email: value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: TextFormField(
                        enabled: false,
                        initialValue: user.phoneNumber,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Ваш телефон',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

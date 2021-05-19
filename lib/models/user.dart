import 'package:flutter/material.dart';

class User {
  String name;
  String surname;
  String email;
  bool isMale;
  String userImage;
  /*DateTime date;*/
  User(
      {@required this.name,
      @required this.surname,
      @required this.email,
      this.isMale,
      this.userImage});
}

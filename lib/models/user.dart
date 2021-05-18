import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String surname;
  String email;
  String userImage;
  /*DateTime date;*/
  User(
      {@required this.name,
      @required this.surname,
      @required this.email,
      @required this.id,
      this.userImage});
}

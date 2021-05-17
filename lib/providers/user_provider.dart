import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:kenguroo/models/user.dart';

class UserProvider with ChangeNotifier {
  Future<void> addUser(User user) async {
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/users.json');
    try {
      await post(url,
          body: json.encode({
            'name': user.name,
            'surname': user.surname,
          }));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}

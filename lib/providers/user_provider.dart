import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:kenguroo/models/user.dart';

class UserProvider with ChangeNotifier {
  Future<void> addUser(
      User user, bool isMale, String userImage, String userId) async {
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/users/$userId.json');
    try {
      await post(url,
          body: json.encode({
            'name': user.name,
            'surname': user.surname,
            'email': user.email,
            'isMale': isMale,
            'userImage': userImage,
          }));
      final userr = u.FirebaseAuth.instance.currentUser;
      await userr.updateEmail(userr.email);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUser(
      User user, bool isMale, String userImage, String userid) async {
    try {
      var url = Uri.parse(
          'https://kenguroo-14a75-default-rtdb.firebaseio.com/users/$userid.json');

      await patch(url,
          body: json.encode({
            'name': user.name,
            'surname': user.surname,
            'email': user.email,
            'isMale': isMale,
            'userImage': userImage,
          }));
      final userr = u.FirebaseAuth.instance.currentUser;
      await userr.updateEmail(user.email);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<User> getUser(String userId) async {
    print(userId);
    final url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/users/$userId.json');
    final response = await get(url);
    final map = json.decode(response.body) as Map<String, dynamic>;
    print(map['email']);
    return User(
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      userImage: map['userImage'],
      isMale: map['isMale'],
    );
  }

  Future<void> setUserType(
      bool isResorator, bool isCourier, bool justUser, String userId) async {
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/usersType/$userId.json');

    try {
      await patch(url,
          body: json.encode({
            'isResorator': isResorator,
            'isCourier': isCourier,
            'justUser': justUser
          }));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> getUsersType(String userId) async {
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/usersType/$userId.json');
    final response = await get(url);
    final map = json.decode(response.body) as Map<String, dynamic>;
    Map<String, dynamic> object = {
      'isCourier': map['isCourier'],
      'isResorator': map['isResorator'],
      'justUser': map['justUser'],
    };
    notifyListeners();
    return object;
  }

  Future<Map<String, dynamic>> getUserImageAndEmail(u.User user) async {
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/users/${user.uid}.json');
    final response = await get(url);
    final map = json.decode(response.body) as Map<String, dynamic>;
    url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/usersType/${user.uid}.json');
    final response2 = await get(url);
    final map2 = json.decode(response2.body) as Map<String, dynamic>;
    Map<String, dynamic> object = {
      'userImageUrl': map['userImage'],
      'userEmail': map['email'],
      'isRestorator': map2['isResorator'],
    };
    notifyListeners();
    return object;
  }
}

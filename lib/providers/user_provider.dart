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

  Future<void> getUserImage(String userId) async {
    final user = u.FirebaseAuth.instance.currentUser;
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/users/$userId.json');
    try {
      final response = await get(url);
      final map = json.decode(response.body) as Map<String, dynamic>;
      if (map != null) {
        String userImageUrl = map.values.last['userImage'];
        await user.updateProfile(photoURL: userImageUrl);
      } else {
        await user.updateProfile(
            photoURL:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg');
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

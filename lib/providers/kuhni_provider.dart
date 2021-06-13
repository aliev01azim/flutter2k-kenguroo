import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:kenguroo/models/cafe_model.dart';

class KuhniProvider with ChangeNotifier {
  List<CafeModel> _cafes = [];
  List<CafeModel> get cafes {
    return [..._cafes];
  }

  List<CafeModel> get nationality {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Нациоанальная'))
        .toList();
  }

  List<CafeModel> get european {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Европейская'))
        .toList();
  }

  List<CafeModel> get burgers {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Бургеры'))
        .toList();
  }

  List<CafeModel> get doners {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Донеры'))
        .toList();
  }

  List<CafeModel> get pizza {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Пицца'))
        .toList();
  }

  List<CafeModel> get sushi {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Суши'))
        .toList();
  }

  List<CafeModel> get rolls {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Роллы'))
        .toList();
  }

  List<CafeModel> get fastfood {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Фастфуд'))
        .toList();
  }

  List<CafeModel> get coffee {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Кофейни'))
        .toList();
  }

  List<CafeModel> get chinese {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Китайская'))
        .toList();
  }

  List<CafeModel> get italian {
    return _cafes
        .where((element) =>
            element.chosenKuhni.any((element) => element == 'Итальянская'))
        .toList();
  }

  Future<void> fetchAndSetCafesKuhni(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes.json');
    try {
      final response = await get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://kenguroo-14a75-default-rtdb.firebaseio.com/userFavorites/$userId.json');
      final favoriteResponse = await get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<CafeModel> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(CafeModel(
            id: prodId,
            time: prodData['time'],
            title: prodData['title'],
            chosenKuhni: prodData['kuhni'].cast<String>(),
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
            discount: prodData['discount']));
      });
      _cafes = loadedProducts;
      notifyListeners();
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }
}

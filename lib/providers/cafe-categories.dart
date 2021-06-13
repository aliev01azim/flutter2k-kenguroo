import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:kenguroo/models/cafe_model.dart';

class CafeCategories with ChangeNotifier {
  List<CafeModel> _cafes = [];
  List<CafeModel> get cafes {
    return [..._cafes];
  }

  List<CafeModel> get favoriteCafes {
    return _cafes.where((element) => element.isFavorite).toList();
  }

  List<CafeModel> get popularCafes {
    return _cafes.where((element) => element.rating >= 4).toList();
  }

  List<CafeModel> get closestCafes {
    return _cafes.where((element) => element.time <= 30).toList();
  }

  List<CafeModel> get discountCafes {
    return _cafes.where((element) => element.discount >= 1).toList();
  }

  CafeModel get lastCafe {
    return _cafes.last;
  }

  Future fetchAndSetCafes(BuildContext context,
      [bool filterByUser = false]) async {
    final box = await Hive.openBox('main-categories');
    final userId = FirebaseAuth.instance.currentUser.uid;

    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes.json?$filterString');
    try {
      final response = await get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      url = Uri.parse(
          'https://kenguroo-14a75-default-rtdb.firebaseio.com/userFavorites/$userId.json');
      final favoriteResponse = await get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<CafeModel> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(CafeModel(
            id: prodId,
            time: prodData['time'],
            // rating:
            //     mostRatedData == null ? false : mostRatedData[prodId] ?? false,
            title: prodData['title'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
            discount: prodData['discount']));
      });
      box.put('data', loadedProducts);
      _cafes = box.get('data');
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

  Future<void> addCafe(CafeModel cafe, List<String> chosenKuhni) async {
    final url = Uri.parse(
        "https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes.json");
    try {
      final response = await post(url,
          body: json.encode({
            'title': cafe.title,
            'imageUrl': cafe.imageUrl,
            'time': cafe.time,
            'discount': cafe.discount,
            'kuhni': chosenKuhni,
          }));
      final newCafe = CafeModel(
          id: json.decode(response.body)['name'],
          time: cafe.time,
          title: cafe.title,
          discount: cafe.discount,
          chosenKuhni: chosenKuhni,
          imageUrl: cafe.imageUrl);
      _cafes.add(newCafe);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateCafe(String id, CafeModel newCafe) async {
    final cafeindex = _cafes.indexWhere((element) => element.id == id);
    if (cafeindex >= 0) {
      try {
        final url = Uri.parse(
            'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes/$id.json');
        await patch(url,
            body: json.encode({
              'title': newCafe.title,
              'imageUrl': newCafe.imageUrl,
              'time': newCafe.time,
            }));
        _cafes[cafeindex] = newCafe;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {}
  }

  Future<void> deleteCafe(String id) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      final existingCafe = _cafes.firstWhere((element) => element.id == id);
      final url = Uri.parse(
          'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes/$userId/$id.json');
      _cafes.remove(existingCafe);
      notifyListeners();
      await delete(url);
    } catch (e) {
      throw e;
    }
  }

  CafeModel findById(String id) {
    return _cafes.firstWhere((element) => element.id == id);
  }
}

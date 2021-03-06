import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:kenguroo/models/food_model.dart';

class FoodCategories with ChangeNotifier {
  List<FoodModel> _foods = [];
  List<FoodModel> get foods {
    return [..._foods];
  }

  List<FoodModel> get favoriteFoods {
    return _foods.where((element) => element.isFavorite).toList();
  }

  List<FoodModel> get discountFoods {
    return _foods.where((element) => element.discount >= 1).toList();
  }

  Future<void> fetchAndSetFoods(BuildContext context, String cafeId) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    final box = await Hive.openBox('food-categories');

    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes/$cafeId/foods.json');
    try {
      final response = await get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      // url = Uri.parse(
      //     'https://kenguroo-14a75-default-rtdb.firebaseio.com/mostRated.json');
      // final mostRatedResponse = await get(url);
      // final mostRatedData = json.decode(mostRatedResponse.body);
      url = Uri.parse(
          'https://kenguroo-14a75-default-rtdb.firebaseio.com/foodFavorites/$userId.json');
      final favoriteResponse = await get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<FoodModel> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(FoodModel(
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
      _foods = box.get('data');
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

  Future<void> addFood(FoodModel food) async {
    final url = Uri.parse(
        "https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes/${food.cafeId}/foods.json");
    try {
      final response = await post(url,
          body: json.encode({
            'title': food.title,
            'imageUrl': food.imageUrl,
            'time': food.time,
            'discount': food.discount,
          }));
      final newFood = FoodModel(
          id: json.decode(response.body)['name'],
          time: food.time,
          title: food.title,
          discount: food.discount,
          imageUrl: food.imageUrl);
      _foods.add(newFood);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateFood(String id, FoodModel newFood) async {
    final foodindex = _foods.indexWhere((element) => element.id == id);
    if (foodindex >= 0) {
      try {
        final url = Uri.parse(
            'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes/${newFood.cafeId}/$id.json');
        await patch(url,
            body: json.encode({
              'title': newFood.title,
              'imageUrl': newFood.imageUrl,
              'time': newFood.time,
            }));
        _foods[foodindex] = newFood;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    }
  }

  // Future<void> deleteFood(String id) async {
  //   try {
  //     final existingCafe = _foods.firstWhere((element) => element.id == id);
  //     final url = Uri.parse(
  //         'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes/$id.json');
  //     _foods.remove(existingCafe);
  //     notifyListeners();
  //     await delete(url);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  FoodModel findById(String id) {
    return _foods.firstWhere((element) => element.id == id);
  }
}

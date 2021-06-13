import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
part 'food_model.g.dart';

@HiveType(typeId: 1)
class FoodModel with ChangeNotifier {
  @HiveField(0)
  String cafeId;
  @HiveField(1)
  String cafeTitle;
  @HiveField(2)
  String id;
  @HiveField(3)
  int quantity;
  @HiveField(4)
  String title;
  @HiveField(5)
  String imageUrl;
  @HiveField(6)
  String time; /*description*/
  @HiveField(7)
  int discount; /*price*/
  @HiveField(8)
  bool isFavorite;
  @HiveField(9)
  int cafeDostavkaTime;
  @HiveField(10)
  int cafeSkidka;
  FoodModel({
    this.cafeId,
    this.cafeDostavkaTime,
    this.cafeSkidka,
    this.quantity,
    this.cafeTitle,
    @required this.id,
    this.time,
    @required this.title,
    this.imageUrl,
    @required this.discount,
    this.isFavorite = false,
  });
  void setFavValue(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String userId) async {
    final favValue = isFavorite;
    try {
      final url = Uri.parse(
          'https://kenguroo-14a75-default-rtdb.firebaseio.com/foodFavorites/$userId/$id.json');
      final response = await put(url, body: json.encode(!isFavorite));
      isFavorite = !isFavorite;
      if (response.statusCode >= 400) {
        setFavValue(favValue);
      }
      notifyListeners();
    } catch (e) {
      setFavValue(favValue);
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
part 'cafe_model.g.dart';

@HiveType(typeId: 0)
class CafeModel with ChangeNotifier {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String imageUrl;
  @HiveField(3)
  int time;
  @HiveField(4)
  int discount;
  @HiveField(5)
  double rating;
  @HiveField(6)
  bool isFavorite;
  @HiveField(7)
  List<String> chosenKuhni;
  CafeModel({
    this.id,
    @required this.time,
    @required this.title,
    @required this.imageUrl,
    @required this.discount,
    this.rating = 0.0,
    this.isFavorite = false,
    this.chosenKuhni,
  });
  void setFavValue(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String userId) async {
    final favValue = isFavorite;
    try {
      final url = Uri.parse(
          'https://kenguroo-14a75-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json');
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

  void addStar(int star) async {
    final url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/mostRated/$id.json');
    final response = await put(url, body: json.encode({'rating': star}));
    if (response.statusCode >= 400) {
      star = 0;
    }
    notifyListeners();
  }
}

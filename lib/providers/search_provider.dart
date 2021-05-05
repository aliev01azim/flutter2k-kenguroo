import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/searching.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<FoodCategory> _suggestions = history;
  List<FoodCategory> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = history;
    } else {
      var url = Uri.parse('https://photon.komoot.io/api/?q=$query');
      // var url = Uri.parse(
      //     'https://kenguroo-14a75-default-rtdb.firebaseio.com/$query');
      final response = await get(url);
      final body = json.decode(utf8.decode(response.bodyBytes));
      final features = body['features'] as List;

      _suggestions =
          features.map((e) => FoodCategory.fromJson(e)).toSet().toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _suggestions = history;
    notifyListeners();
  }
}

const List<FoodCategory> history = [];

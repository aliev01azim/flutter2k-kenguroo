import 'package:flutter/material.dart';

class FoodCategory {
  final String restourants;
  final String foods;
  final String categories;
  const FoodCategory({
    @required this.restourants,
    this.foods,
    @required this.categories,
  })  : assert(restourants != null),
        assert(categories != null);

  bool get hasState => restourants?.isNotEmpty == true;
  bool get hasCountry => categories?.isNotEmpty == true;

  bool get isCountry => hasCountry && restourants == categories;
  bool get isState => hasState && restourants == foods;

  factory FoodCategory.fromJson(Map<String, dynamic> map) {
    final props = map['properties'];

    return FoodCategory(
      restourants: props['restourants'] ?? '',
      foods: props['foods'] ?? '',
      categories: props['categories'] ?? '',
    );
  }

  String get address {
    if (isCountry) return categories;
    return '$restourants, $level2Address';
  }

  String get addressShort {
    if (isCountry) return categories;
    return '$restourants, $categories';
  }

  String get level2Address {
    if (isCountry || isState || !hasState) return categories;
    if (!hasCountry) return foods;
    return '$foods, $categories';
  }

  @override
  String toString() =>
      'Place(name: $restourants, state: $foods, country: $categories)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FoodCategory &&
        o.restourants == restourants &&
        o.foods == foods &&
        o.categories == categories;
  }

  @override
  int get hashCode =>
      restourants.hashCode ^ foods.hashCode ^ categories.hashCode;
}

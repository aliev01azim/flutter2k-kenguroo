import 'package:flutter/material.dart';

import 'food_categories.dart';

class Cart with ChangeNotifier {
  Map<String, FoodModel> _items = {};

  Map<String, FoodModel> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int _quantity = 0;
  int get quantity {
    return _quantity;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.discount * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    int price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _quantity = _quantity + 1;
      _items.update(
        productId,
        (existingCartItem) => FoodModel(
          id: existingCartItem.id,
          title: existingCartItem.title,
          discount: existingCartItem.discount,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _quantity = 1;
      _items.putIfAbsent(
        productId,
        () => FoodModel(
          id: DateTime.now().toString(),
          title: title,
          discount: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _quantity = _quantity - 1;
      _items.update(
          productId,
          (existingCartItem) => FoodModel(
                id: existingCartItem.id,
                title: existingCartItem.title,
                discount: existingCartItem.discount,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _quantity = 0;
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:kenguroo/models/food_model.dart';

class Cart with ChangeNotifier {
  Map<String, FoodModel> _items = {};

  Map<String, FoodModel> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.discount * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String foodId,
    int price,
    String title,
    String imageUrl,
    int quantity,
    String cafeId,
    String cafeTitle,
    int cafeDostavkaTime,
    int cafeSkidka,
  ) {
    if (_items.containsKey(foodId)) {
      _items.update(
        foodId,
        (existingCartItem) => FoodModel(
          id: existingCartItem.id,
          title: existingCartItem.title,
          cafeTitle: existingCartItem.cafeTitle,
          discount: existingCartItem.discount,
          imageUrl: existingCartItem.imageUrl,
          cafeId: existingCartItem.cafeId,
          cafeDostavkaTime: existingCartItem.cafeDostavkaTime,
          cafeSkidka: existingCartItem.cafeSkidka,
          quantity: quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        foodId,
        () => FoodModel(
          id: foodId,
          title: title,
          discount: price,
          imageUrl: imageUrl,
          cafeId: cafeId,
          cafeTitle: cafeTitle,
          quantity: quantity,
          cafeDostavkaTime: cafeDostavkaTime,
          cafeSkidka: cafeSkidka,
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
    if (_items[productId].quantity > 0) {
      _items.update(
          productId,
          (existingCartItem) => FoodModel(
                id: existingCartItem.id,
                title: existingCartItem.title,
                discount: existingCartItem.discount,
                cafeId: existingCartItem.cafeId,
                cafeTitle: existingCartItem.cafeTitle,
                imageUrl: existingCartItem.imageUrl,
                cafeDostavkaTime: existingCartItem.cafeDostavkaTime,
                cafeSkidka: existingCartItem.cafeSkidka,
                quantity: existingCartItem.quantity,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

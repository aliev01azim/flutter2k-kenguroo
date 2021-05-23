import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cart.dart';
import 'package:kenguroo/providers/food_categories.dart';
import 'package:provider/provider.dart';

class FoodsGridViewItem extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser.uid;
  final String cafeTitle;
  final String cafeId;
  final FoodModel food;
  final int cafeDostavkaTime;
  final int cafeSkidka;
  FoodsGridViewItem(this.food, this.cafeId, this.cafeTitle,
      this.cafeDostavkaTime, this.cafeSkidka);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            _modalBottomSheetMenu(
                context, food, cafeId, cafeTitle, cafeDostavkaTime, cafeSkidka);
          },
          child: FadeInImage(
            placeholder: AssetImage('assets/images/food-placeholder.jpg'),
            image: food.imageUrl.startsWith('http')
                ? NetworkImage(food.imageUrl)
                : FileImage(File(food.imageUrl)),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<FoodModel>(
            builder: (ctx, food, _) => IconButton(
              icon: Icon(
                food.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                food.toggleFavoriteStatus(userId);
              },
            ),
          ),
          title: Text(
            food.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              _modalBottomSheetMenu(context, food, cafeId, cafeTitle,
                  cafeDostavkaTime, cafeSkidka);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

void _modalBottomSheetMenu(BuildContext context, FoodModel food, String cafeId,
    String cafeTitle, int cafeDostavkaTime, int cafeSkidka) {
  int _quantity = 0;
  final cart = Provider.of<Cart>(context, listen: false);
  showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Container(
                            height: 220,
                            child: Image(
                              image: food.imageUrl.startsWith('http')
                                  ? NetworkImage(food.imageUrl)
                                  : FileImage(File(food.imageUrl)),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Row(
                            children: [
                              Text(food.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                '${_quantity * food.discount}',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              food.time,
                              textAlign: TextAlign.start,
                              softWrap: true,
                              maxLines: 5,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 130,
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _quantity--;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 8),
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                                color: Colors.grey.shade200),
                                            child: Center(
                                              child: Text(
                                                '-',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(_quantity.toString()),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _quantity++;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 8),
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                                color: Colors.grey.shade200),
                                            child: Center(
                                              child: Text(
                                                '+',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    cart.addItem(
                                        food.id,
                                        food.discount,
                                        food.title,
                                        food.imageUrl,
                                        _quantity,
                                        cafeId,
                                        cafeTitle,
                                        cafeDostavkaTime,
                                        cafeSkidka);
                                    setState(() {
                                      _quantity = 0;
                                    });
                                  },
                                  child: Text('Добавить'),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 25))),
                                )
                              ]),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        );
      });
}

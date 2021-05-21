import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo/providers/food_categories.dart';
import 'package:provider/provider.dart';

class FoodsGridViewItem extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser.uid;
  final FoodModel food;
  FoodsGridViewItem(this.food);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).pushNamed(
            //   ProductDetailScreen.routeName,
            //   arguments: product.id,
            // );
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

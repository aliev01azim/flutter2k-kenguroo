import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:kenguroo/screens/food_detail_screen.dart';

class FavListViewItem extends StatelessWidget {
  final CafeModel cafe;
  FavListViewItem(this.cafe);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cafe.title),
      subtitle: Text(cafe.time.toString()),
      onTap: () {
        Navigator.of(context)
            .pushNamed(FoodDetailScreen.routeName, arguments: cafe.id);
      },
    );
  }
}
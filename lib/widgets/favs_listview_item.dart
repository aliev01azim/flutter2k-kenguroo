import 'package:flutter/material.dart';
import 'package:kenguroo/models/cafe_model.dart';
import 'package:kenguroo/screens/cafe_detail_screen.dart';

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
            .pushNamed(CafeDetailScreen.routeName, arguments: cafe.id);
      },
    );
  }
}

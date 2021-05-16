import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:kenguroo/widgets/favs_listview_item.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = '/favorites-screen';
  @override
  Widget build(BuildContext context) {
    final favs =
        Provider.of<CafeCategories>(context, listen: false).favoriteCafes;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.green),
      ),
      body: ListView.builder(
        itemCount: favs.length,
        itemBuilder: (context, index) => FavListViewItem(favs[index]),
      ),
    );
  }
}

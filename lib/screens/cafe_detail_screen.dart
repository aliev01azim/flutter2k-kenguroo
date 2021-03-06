import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kenguroo/models/cafe_model.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:kenguroo/providers/food_categories.dart';
import 'package:kenguroo/widgets/FoodsGridViewItem.dart';
import 'package:provider/provider.dart';

class CafeDetailScreen extends StatefulWidget {
  static const routeName = '/cafe-detail-screen';

  @override
  _CafeDetailScreenState createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen> {
  CafeModel cafe;
  Future<void> _fetchFoods(BuildContext context) async {
    final routeId = ModalRoute.of(context).settings.arguments as String;
    cafe =
        Provider.of<CafeCategories>(context, listen: false).findById(routeId);
    await Provider.of<FoodCategories>(context, listen: false)
        .fetchAndSetFoods(context, cafe.id);
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                placeHolderTitle('О ресторане'),
                placeHolderText('Адрес', 'Проспект Мира 85'),
                placeHolderText('Время приема заказа', 'Пн: 10:00-22:30'),
                placeHolderTitle('Вт: 10:00-22:30'),
                placeHolderTitle('Ср: 10:00-22:30'),
                placeHolderTitle('Чт: 10:00-22:30'),
                placeHolderTitle('Пт: 10:00-22:30'),
                placeHolderTitle('Сб: 10:00-22:30'),
                placeHolderTitle('Вс: 10:00-22:30'),
              ],
            ),
          );
        });
  }

  void _showModal2(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              placeHolderTitle('Условия доставки'),
              placeHolderTitle('99сом: до 3.0 км'),
              placeHolderTitle('149сом: до 5.0 км'),
            ],
          );
        });
  }

  placeHolderTitle(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  placeHolderTitle2(String title) {
    return ListTile(
      title: Text(
        title,
      ),
    );
  }

  placeHolderText(String label, String title) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
      ),
      subtitle: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = Provider.of<FoodCategories>(context).foods;
    return Scaffold(
      body: FutureBuilder(
        future: _fetchFoods(context),
        builder: (context, snapshot) => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              titleTextStyle: TextStyle(),
              title: Text(
                cafe.title,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: cafe.id,
                  child: Image.network(
                    cafe.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10),
                  Text(
                    cafe.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.brown,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            cafe.rating.toString(),
                            style: TextStyle(color: Colors.brown),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.directions_run_rounded),
                          SizedBox(
                            width: 3,
                          ),
                          Text('${cafe.time} мин.'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.sports_hockey,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '${cafe.discount}%',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black87)),
                          onPressed: () => _showModal(context),
                          icon: Icon(Icons.ad_units_rounded),
                          label: Text('О ресторане')),
                      TextButton.icon(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black87)),
                          onPressed: () => _showModal2(context),
                          icon: Icon(Icons.directions_run_rounded),
                          label: Text('Доставка 99с-149с'))
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Foods',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ChangeNotifierProvider.value(
                    value: foods[index],
                    child: FoodsGridViewItem(
                      foods[index],
                      cafe.id,
                      cafe.title,
                      cafe.time,
                      cafe.discount,
                    )),
                childCount: foods.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

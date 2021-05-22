import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cart.dart';
import 'package:kenguroo/screens/account.dart';
import 'package:kenguroo/screens/cart_screen.dart';
import 'package:kenguroo/screens/categories_screen.dart';
import 'package:kenguroo/screens/look_screen.dart' as LookScreen;
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  List<Map<String, Object>> pages;
  @override
  void initState() {
    pages = [
      {'page': CategoriesScreen()},
      {'page': LookScreen.LookScreen()},
      {'page': CartScreen()},
      {'page': Account()},
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 10.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedIconTheme: IconThemeData(color: Colors.grey[500]),
        selectedIconTheme: IconThemeData(color: Colors.green),
        currentIndex: _currentIndex,
        onTap: (val) {
          setState(() {
            _currentIndex = val;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
            ),
            label: 'categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'look',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              alignment: Alignment.center,
              children: [
                Icon(Icons.shopping_cart),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: EdgeInsets.all(1.0),
                    // color: Theme.of(context).accentColor,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 13,
                      minHeight: 13,
                    ),
                    child: Consumer<Cart>(
                      builder: (context, value, _) => Text(
                        value.itemCount.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            label: 'cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.verified_user_sharp,
            ),
            label: 'account',
          ),
        ],
      ),
    );
  }
}

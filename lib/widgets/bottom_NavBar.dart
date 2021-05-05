import 'package:flutter/material.dart';
import 'package:kenguroo/screens/account.dart';
import 'package:kenguroo/screens/cart_screen.dart';
import 'package:kenguroo/screens/categories_screen.dart';
import 'package:kenguroo/screens/look_screen.dart' as LookScreen;

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
            icon: Icon(
              Icons.shopping_cart,
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

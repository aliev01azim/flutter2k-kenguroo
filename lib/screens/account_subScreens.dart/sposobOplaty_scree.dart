import 'package:flutter/material.dart';

class SposobOplaty extends StatefulWidget {
  static const routeName = '/account/sposobOplaty';
  @override
  _SposobOplatyState createState() => _SposobOplatyState();
}

class _SposobOplatyState extends State<SposobOplaty> {
  int _currentIndex = 1;
  var children = [
    'Банковская карта',
    'Наличными курьеру',
    'Мобильный кошелек Эльсом',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Способы оплаты',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, index) =>
              item(children[index], _currentIndex == index, index),
        ),
      ),
    );
  }

  Widget item(String title, isSelected, index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ListTile(
        minVerticalPadding: 10,
        leading: Icon(
          Icons.calendar_view_day_outlined,
          color: isSelected ? Colors.white : Colors.green,
        ),
        tileColor: isSelected ? Colors.green : Colors.white,
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

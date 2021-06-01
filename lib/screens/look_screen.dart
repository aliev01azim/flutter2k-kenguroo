import 'package:flutter/material.dart';
import 'package:kenguroo/screens/kuhnya_category_screen.dart';
import 'package:kenguroo/screens/look_poiskovik_screen.dart';

class LookScreen extends StatelessWidget {
  // Future<void> _fetch(BuildContext context) async {
  //   await Provider.of<KuhniProvider>(context, listen: false)
  //       .fetchAndSetCafesKuhni(context);
  // }

  const LookScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: TextField(
            onTap: () {
              Navigator.pushNamed(context, LookPoiskovikScreen.routeName);
            },
            decoration: InputDecoration(
              hintText: 'Поиск',
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: null,
              enabledBorder: null,
              disabledBorder: null,
              errorBorder: null,
              focusedBorder: InputBorder.none,
            ),
            readOnly: true,
            showCursor: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70, left: 32, right: 32),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 30, mainAxisSpacing: 30),
            children: [
              lookGridItem('Нациоанальная', context),
              lookGridItem('Европейская', context),
              lookGridItem('Бургеры', context),
              lookGridItem('Донеры', context),
              lookGridItem('Пицца', context),
              lookGridItem('Суши', context),
              lookGridItem('Роллы', context),
              lookGridItem('Фастфуд', context),
              lookGridItem('Кофейни', context),
              lookGridItem('Китайская', context),
              lookGridItem('Итальянская', context),
            ],
          ),
        ),
      ],
    );
  }

  Widget lookGridItem(String title, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(KuhnyaCategoryScreen.routeName, arguments: title);
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/food-placeholder.jpg'),
          ),
        ),
        child: Center(
            child: Text(
          title,
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}

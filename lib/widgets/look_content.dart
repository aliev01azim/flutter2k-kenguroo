import 'package:flutter/material.dart';
import 'package:kenguroo/providers/kuhni_provider.dart';
import 'package:kenguroo/screens/kuhnya_category_screen.dart';
import 'package:provider/provider.dart';

class LookContent extends StatelessWidget {
  Future<void> _fetch(BuildContext context) async {
    await Provider.of<KuhniProvider>(context, listen: false)
        .fetchAndSetCafesKuhni(context);
  }

  const LookContent({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetch(context),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30),
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

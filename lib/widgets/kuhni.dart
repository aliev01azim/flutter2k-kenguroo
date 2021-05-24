import 'package:flutter/material.dart';

class Kuhnya {
  const Kuhnya(this.name, this.icon);
  final String name;
  final Icon icon;
}

class Kuhni extends StatefulWidget {
  State createState() => _KuhniState();
  final Function callBack;
  Kuhni(this.callBack);
}

class _KuhniState extends State<Kuhni> {
  List<String> choices = [];
  Kuhnya selectedKuhnya;
  List<Kuhnya> kuhni = <Kuhnya>[
    const Kuhnya(
        'Национальная',
        Icon(
          Icons.local_convenience_store_sharp,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Европейская',
        Icon(
          Icons.flag,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Бургеры',
        Icon(
          Icons.fastfood_outlined,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Донеры',
        Icon(
          Icons.food_bank,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Пицца',
        Icon(
          Icons.local_pizza_sharp,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Суши',
        Icon(
          Icons.breakfast_dining,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Роллы',
        Icon(
          Icons.camera_roll_outlined,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Фастфуд',
        Icon(
          Icons.fastfood_outlined,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Кофейни',
        Icon(
          Icons.emoji_food_beverage_rounded,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Китайская',
        Icon(
          Icons.airline_seat_flat_angled_sharp,
          color: const Color(0xFF167F67),
        )),
    const Kuhnya(
        'Итальянская',
        Icon(
          Icons.format_italic,
          color: const Color(0xFF167F67),
        )),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<Kuhnya>(
        hint: Text("Выберите Кухни"),
        value: selectedKuhnya,
        onChanged: (Kuhnya value) {
          setState(() {
            selectedKuhnya = value;
            choices.add(value.name);
          });
          widget.callBack(choices);
        },
        items: kuhni.map((Kuhnya kuhnya) {
          return DropdownMenuItem<Kuhnya>(
            value: kuhnya,
            child: Row(
              children: <Widget>[
                kuhnya.icon,
                SizedBox(
                  width: 10,
                ),
                Text(
                  kuhnya.name,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

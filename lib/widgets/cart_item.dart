import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cart.dart';
import 'package:kenguroo/providers/food_categories.dart';
import 'package:kenguroo/screens/cafe_detail_screen.dart';
import 'package:provider/provider.dart';

class CartItems extends StatefulWidget {
  final FoodModel food;
  final bool isLast;
  CartItems(this.food, this.isLast);

  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Cart>(context);
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: Text(widget.food.cafeTitle),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CafeDetailScreen.routeName,
                    arguments: widget.food.cafeId);
              },
              child: Text(
                '-> в ресторан',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
            ),
          ),
          Divider(),
          listTile(
              widget.food.title,
              widget.food.quantity * widget.food.discount,
              widget.food.quantity,
              data,
              true),
          Divider(),
          if (widget.isLast) listTile('Контейнер-соусница', 5, 1),
          if (widget.isLast) Divider(),
          if (widget.isLast) listTile('Контейнер для еды', 15, 1),
          if (widget.isLast) Divider(),
          if (widget.isLast)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
              child: Column(
                children: [
                  row('Стоимость блюд', data.totalAmount),
                  row('Доставка', widget.food.cafeDostavkaTime * 15.0),
                  row('Скидка',
                      data.totalAmount * widget.food.cafeSkidka / 100),
                  row(
                      'Итого:',
                      data.totalAmount -
                          (data.totalAmount * widget.food.cafeSkidka / 100 +
                              widget.food.cafeDostavkaTime * 15.0)),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget listTile(String title, int price, int quantity,
      [Cart data, bool show = false]) {
    return ListTile(
      contentPadding: EdgeInsets.only(
          top: 12, bottom: widget.isLast ? 30 : 12, left: 5, right: 15),
      isThreeLine: true,
      leading: Image.network(
        widget.food.imageUrl,
        fit: BoxFit.cover,
      ),
      title: Text(
        title,
        maxLines: 1,
      ),
      subtitle: Column(children: [
        Row(
          children: [
            Text(
              'Стоимость',
              maxLines: 1,
              style: TextStyle(color: Colors.grey.shade300),
            ),
            Text(
              'Количество',
              maxLines: 1,
              style: TextStyle(color: Colors.grey.shade300),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        Row(
          children: [
            Text(
              '$price c',
              maxLines: 1,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: show ? 130 : 30,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.food.quantity--;
                        });
                        data.removeSingleItem(widget.food.id);
                      },
                      child: show
                          ? Container(
                              margin: EdgeInsets.only(right: 8),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45),
                                  color: Colors.grey.shade200),
                              child: Center(
                                child: Text(
                                  '-',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ),
                    Text(quantity.toString()),
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.food.quantity++;
                        });
                        data.addItem(
                            widget.food.id,
                            widget.food.discount,
                            widget.food.title,
                            widget.food.imageUrl,
                            widget.food.quantity,
                            widget.food.cafeId,
                            widget.food.cafeTitle,
                            widget.food.cafeDostavkaTime,
                            widget.food.cafeSkidka);
                      },
                      child: show
                          ? Container(
                              margin: EdgeInsets.only(left: 8),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45),
                                  color: Colors.grey.shade200),
                              child: Center(
                                child: Text(
                                  '+',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ),
                  ]),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ]),
    );
  }

  Widget row(String names, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(names),
          Expanded(child: Text('.' * 100, maxLines: 1)),
          Text('${total.toStringAsFixed(0)} c'),
        ],
      ),
    );
  }
}

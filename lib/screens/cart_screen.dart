import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cart.dart';
import 'package:kenguroo/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: cart.itemCount > 0
          ? Column(
              children: [
                if (cart.itemCount > 1)
                  Visibility(
                    visible: isVisible,
                    child: Stack(children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        margin: EdgeInsets.only(bottom: 20),
                        color: Colors.grey.shade300,
                        child: Text(
                            'Ваш заказ сформирован из нескольких заведений,он будет разделен по принципу 1заведение - 1 заказ'),
                      ),
                      Positioned(
                        child: TextButton(
                          child:
                              Text('x', style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            setState(() {
                              isVisible = false;
                            });
                          },
                        ),
                        right: -13,
                        top: -12,
                      ),
                    ]),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: (context, index) => CartItems(
                        cart.items.values.toList()[index],
                        cart.items.values.toList().last ==
                            cart.items.values.toList()[index]),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_shopping_cart_rounded,
                    size: 50,
                    color: Colors.green,
                  ),
                  Text('Your cart is empty yet!')
                ],
              ),
            ),
    );
  }
}

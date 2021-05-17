import 'package:flutter/material.dart';

class SpravkaScreen extends StatelessWidget {
  static const routeName = '/spravka-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Справка'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (_, index) => Text('Some text'),
            separatorBuilder: (_, asd) => Divider(),
            itemCount: 30),
      ),
    );
  }
}

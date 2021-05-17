import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  static const routeName = '/aboutApp-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О приложении'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (_, index) => Text('About App'),
            separatorBuilder: (_, asd) => Divider(),
            itemCount: 30),
      ),
    );
  }
}

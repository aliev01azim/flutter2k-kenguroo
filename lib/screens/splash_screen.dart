import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          duration: Duration(seconds: 1),
          size: 120,
        ),
      ),
    );
  }
}

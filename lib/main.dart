import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:kenguroo/providers/search_provider.dart';
import 'package:kenguroo/providers/auth_provider.dart';
import 'package:kenguroo/screens/account_subScreens.dart/favorites_screen.dart';
import 'package:kenguroo/screens/auth_screen.dart';
import 'package:kenguroo/screens/food_detail_screen.dart';
import 'package:provider/provider.dart';

import 'widgets/bottom_NavBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        theme: ThemeData(
            iconTheme: IconThemeData(color: Colors.black),
            appBarTheme: AppBarTheme(backgroundColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('error data'),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.hasData) {
                    // return AddingCafeScreen();
                    return Scaffold(
                      bottomNavigationBar: BottomNavBar(),
                    );
                  } else if (userSnapshot.hasError) {
                    return Text(userSnapshot.error);
                  }
                  return AuthScreen();
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
        routes: {
          FoodDetailScreen.routeName: (context) => FoodDetailScreen(),
          FavoritesScreen.routeName: (context) => FavoritesScreen(),
        },
      ),
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: CafeCategories()),
        ChangeNotifierProvider.value(value: SearchModel()),
      ],
    );
  }
}

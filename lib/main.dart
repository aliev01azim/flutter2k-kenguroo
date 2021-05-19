import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:kenguroo/providers/location_provider.dart';
import 'package:kenguroo/providers/search_provider.dart';
import 'package:kenguroo/providers/auth_provider.dart';
import 'package:kenguroo/providers/user_provider.dart';
import 'package:kenguroo/screens/account_subScreens.dart/favorites_screen.dart';
import 'package:kenguroo/screens/account_subScreens.dart/partners.dart';
import 'package:kenguroo/screens/account_subScreens.dart/settings_screen.dart';
import 'package:kenguroo/screens/account_subScreens.dart/sposobOplaty_scree.dart';
import 'package:kenguroo/screens/account_subScreens.dart/spravka_screen.dart';
import 'package:kenguroo/screens/auth_screen.dart';
import 'package:kenguroo/screens/food_detail_screen.dart';
import 'package:kenguroo/screens/location_screen.dart';
import 'package:kenguroo/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'screens/account_subScreens.dart/about_app_screen.dart';
import 'widgets/bottom_NavBar.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.black),
          appBarTheme: AppBarTheme(
            backwardsCompatibility: false,
            color: Colors.white,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.green),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
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
                    // return MapScreen();
                  } else if (userSnapshot.hasError) {
                    return Text(userSnapshot.error);
                  } else if (userSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Scaffold(body: CircularProgressIndicator());
                  }
                  return AuthScreen();
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            return Scaffold(body: CircularProgressIndicator());
          },
        ),
        routes: {
          FoodDetailScreen.routeName: (context) => FoodDetailScreen(),
          FavoritesScreen.routeName: (context) => FavoritesScreen(),
          SposobOplaty.routeName: (context) => SposobOplaty(),
          SpravkaScreen.routeName: (context) => SpravkaScreen(),
          AboutAppScreen.routeName: (context) => AboutAppScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          PartnersScreen.routeName: (context) => PartnersScreen(),
        },
      ),
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: CafeCategories()),
        ChangeNotifierProvider.value(value: SearchModel()),
        ChangeNotifierProvider.value(value: LocationProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
      ],
    );
  }
}

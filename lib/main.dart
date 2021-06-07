import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kenguroo/providers/cart.dart';
import 'package:kenguroo/providers/food_categories.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:kenguroo/providers/kuhni_provider.dart';
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
import 'package:kenguroo/screens/cafe_detail_screen.dart';
import 'package:kenguroo/screens/kuhnya_category_screen.dart';
import 'package:kenguroo/screens/look_poiskovik_screen.dart';
import 'package:kenguroo/screens/splash_screen.dart';
import 'package:kenguroo/screens/addingCafe.dart';
import 'package:kenguroo/screens/test.dart';
import 'package:provider/provider.dart';

import 'screens/account_subScreens.dart/about_app_screen.dart';
import 'screens/addingFood.dart';
import 'screens/location_screen.dart';
import 'widgets/bottom_NavBar.dart';

void main() async {
  await Hive.initFlutter();
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
                    return BottomNavBar();
                    // return MapScreen();
                  } else if (userSnapshot.hasError) {
                    return Text(userSnapshot.error);
                  } else if (userSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SplashScreen();
                  }
                  return AuthScreen();
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            return SplashScreen();
          },
        ),
        routes: {
          CafeDetailScreen.routeName: (context) => CafeDetailScreen(),
          FavoritesScreen.routeName: (context) => FavoritesScreen(),
          SposobOplaty.routeName: (context) => SposobOplaty(),
          SpravkaScreen.routeName: (context) => SpravkaScreen(),
          AboutAppScreen.routeName: (context) => AboutAppScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          PartnersScreen.routeName: (context) => PartnersScreen(),
          AddingCafeScreen.routeName: (context) => AddingCafeScreen(),
          AddingFoodScreen.routeName: (context) => AddingFoodScreen(),
          KuhnyaCategoryScreen.routeName: (context) => KuhnyaCategoryScreen(),
          LookPoiskovikScreen.routeName: (context) => LookPoiskovikScreen(),
        },
      ),
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: CafeCategories()),
        ChangeNotifierProvider.value(value: SearchModel()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: FoodCategories()),
        ChangeNotifierProvider.value(value: KuhniProvider()),
        ChangeNotifierProvider.value(value: Cart())
      ],
    );
  }
}

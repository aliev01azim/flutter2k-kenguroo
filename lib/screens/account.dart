import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo/providers/auth_provider.dart';
import 'package:kenguroo/providers/user_provider.dart';
import 'package:kenguroo/screens/account_subScreens.dart/about_app_screen.dart';
import 'package:kenguroo/screens/account_subScreens.dart/favorites_screen.dart';
import 'package:kenguroo/screens/account_subScreens.dart/partners.dart';
import 'package:kenguroo/screens/account_subScreens.dart/settings_screen.dart';
import 'package:kenguroo/screens/account_subScreens.dart/sposobOplaty_scree.dart';
import 'package:kenguroo/screens/account_subScreens.dart/spravka_screen.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  Future<void> _getUserImage(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false)
        .getUserImage(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Профиль',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: _getUserImage(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _getUserImage(context),
                child: SingleChildScrollView(
                  physics:
                      ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            foregroundImage: FileImage(File(user.photoURL)),
                            backgroundColor: Colors.grey[500],
                            child: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(user.phoneNumber),
                        subtitle: Text('asdasd@mail'),
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.favorite_border,
                          color: IconTheme.of(context).color,
                        ),
                        title: Text("Избранное"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FavoritesScreen.routeName);
                        },
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.dashboard,
                          color: IconTheme.of(context).color,
                        ),
                        title: Text("Способы оплаты"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SposobOplaty.routeName);
                        },
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.settings,
                          color: IconTheme.of(context).color,
                        ),
                        title: Text("Настройки аккаунта"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SettingsScreen.routeName);
                        },
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.bus_alert,
                          color: IconTheme.of(context).color,
                        ),
                        title: Text("Стать партнером"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PartnersScreen.routeName);
                        },
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.room_preferences_rounded,
                          color: IconTheme.of(context).color,
                        ),
                        title: Text("Справка"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SpravkaScreen.routeName);
                        },
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.add_box_outlined,
                          color: IconTheme.of(context).color,
                        ),
                        title: Text("О приложении"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AboutAppScreen.routeName);
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Выйти",
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

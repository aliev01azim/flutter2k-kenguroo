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
import 'package:kenguroo/screens/addingCafe.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _isLoading = false;

  final user = FirebaseAuth.instance.currentUser;

  Map<String, dynamic> path;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUserImageAndEmailAndUserChecking();
  }

  Future<void> _getUserImageAndEmailAndUserChecking() async {
    setState(() {
      _isLoading = true;
    });
    path = await Provider.of<UserProvider>(context, listen: false)
        .getUserImageAndEmail(user);
    setState(() {
      _isLoading = false;
    });
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
      body: RefreshIndicator(
        onRefresh: () => _getUserImageAndEmailAndUserChecking(),
        child: SingleChildScrollView(
          physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                  child: !_isLoading
                      ? CircleAvatar(
                          foregroundImage:
                              FileImage(File(path['userImageUrl'])),
                          backgroundColor: Colors.grey[500],
                          child: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.white,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(),
                        ),
                ),
                title: Text(user.phoneNumber),
                subtitle: !_isLoading
                    ? Text(path['userEmail'])
                    : Container(
                        height: 10,
                        color: Colors.grey,
                      ),
              ),
              _isLoading == true || path['isRestorator'] == true
                  ? ListTile(
                      trailing: Icon(
                        Icons.restaurant,
                        color: IconTheme.of(context).color,
                      ),
                      title: Text("Добавить ресторан"),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AddingCafeScreen.routeName);
                      },
                    )
                  : ListTile(
                      title: Container(
                        color: Colors.grey,
                        height: 20,
                      ),
                    ),
              ListTile(
                trailing: Icon(
                  Icons.favorite_border,
                  color: IconTheme.of(context).color,
                ),
                title: Text("Избранное"),
                onTap: () {
                  Navigator.of(context).pushNamed(FavoritesScreen.routeName);
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.dashboard,
                  color: IconTheme.of(context).color,
                ),
                title: Text("Способы оплаты"),
                onTap: () {
                  Navigator.of(context).pushNamed(SposobOplaty.routeName);
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.settings,
                  color: IconTheme.of(context).color,
                ),
                title: Text("Настройки аккаунта"),
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.bus_alert,
                  color: IconTheme.of(context).color,
                ),
                title: Text("Стать партнером"),
                onTap: () {
                  Navigator.of(context).pushNamed(PartnersScreen.routeName);
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.room_preferences_rounded,
                  color: IconTheme.of(context).color,
                ),
                title: Text("Справка"),
                onTap: () {
                  Navigator.of(context).pushNamed(SpravkaScreen.routeName);
                },
              ),
              ListTile(
                trailing: Icon(
                  Icons.add_box_outlined,
                  color: IconTheme.of(context).color,
                ),
                title: Text("О приложении"),
                onTap: () {
                  Navigator.of(context).pushNamed(AboutAppScreen.routeName);
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
    );
  }
}

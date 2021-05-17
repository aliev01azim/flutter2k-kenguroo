import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo/providers/auth_provider.dart';
import 'package:kenguroo/screens/account_subScreens.dart/about_app_screen.dart';
import 'package:kenguroo/screens/account_subScreens.dart/favorites_screen.dart';
import 'package:kenguroo/screens/account_subScreens.dart/settings_screen.dart';
import 'package:kenguroo/screens/account_subScreens.dart/sposobOplaty_scree.dart';
import 'package:kenguroo/screens/account_subScreens.dart/spravka_screen.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Профиль',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
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
              // onTap: () {
              //     print("About Clicked");
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => AboutScreen()),
              //   );
              // },
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
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PartnersScreen extends StatefulWidget {
  static const routeName = '/partners-screen';

  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  final userId = FirebaseAuth.instance.currentUser.uid;
  bool isCourier = false;
  bool isRestorator = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Стать партнером"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Column(
                children: [
                  Text(
                    !isCourier && !isRestorator
                        ? 'Станьте партнером Kenguroo'
                        : 'Теперь вы наш партнер!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: isRestorator || isCourier
                        ? null
                        : () async {
                            setState(() {
                              isCourier = !isCourier;
                              isLoading = true;
                            });
                            await Provider.of<UserProvider>(context,
                                    listen: false)
                                .setUserType(
                                    isRestorator, isCourier, false, userId);
                            setState(() {
                              isLoading = false;
                            });
                          },
                    splashColor: null,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.shade500, width: 1),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 25, bottom: 14),
                      child: Row(
                        children: [
                          Text(
                            'Хочу стать курьером',
                            style: TextStyle(
                                color: isRestorator || isCourier
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                          Icon(Icons.arrow_right)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: isCourier || isRestorator
                        ? null
                        : () async {
                            setState(() {
                              isRestorator = !isRestorator;
                              isLoading = true;
                            });
                            await Provider.of<UserProvider>(context,
                                    listen: false)
                                .setUserType(
                                    isRestorator, isCourier, false, userId);
                            setState(() {
                              isLoading = false;
                            });
                          },
                    splashColor: null,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.shade500, width: 1),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 25, bottom: 14),
                      child: Row(
                        children: [
                          Text(
                            'У меня есть ресторан',
                            style: TextStyle(
                                color: isCourier || isRestorator
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                          Icon(Icons.arrow_right)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        isRestorator = false;
                        isCourier = false;
                        isLoading = true;
                      });
                      await Provider.of<UserProvider>(context, listen: false)
                          .setUserType(isRestorator, isCourier, true, userId);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    splashColor: Colors.green,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.shade500, width: 1),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 25, bottom: 14),
                      child: Row(
                        children: [
                          Text(
                            'Передумал!',
                            style: TextStyle(
                                color: !isCourier || !isRestorator
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                          Icon(Icons.arrow_right)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

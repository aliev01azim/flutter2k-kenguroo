import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenguroo/models/cafe_model.dart';
import 'package:kenguroo/screens/cafe_detail_screen.dart';
import 'package:provider/provider.dart';

class ListViewItem extends StatelessWidget {
  final uid = FirebaseAuth.instance.currentUser.uid;
  final CafeModel cafe;
  ListViewItem(this.cafe);
  @override
  Widget build(BuildContext context) {
    final witdh = MediaQuery.of(context).size.width * 0.8;
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CafeDetailScreen.routeName, arguments: cafe.id);
      },
      child: Container(
        padding: EdgeInsets.only(right: 5),
        width: witdh,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      height: 130,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/food-placeholder.jpg'),
                        image: NetworkImage(
                          cafe.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Consumer<CafeModel>(
                      builder: (context, value, child) => IconButton(
                          icon: Icon(value.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            value.toggleFavoriteStatus(uid);
                          }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(cafe.title, style: Theme.of(context).textTheme.headline5),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.brown,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        cafe.rating.toString(),
                        style: TextStyle(color: Colors.brown),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.directions_run_rounded),
                      SizedBox(
                        width: 3,
                      ),
                      Text('${cafe.time} ??????.'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.sports_hockey,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        '${cafe.discount}%',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kenguroo/providers/cafe-categories.dart';
import 'package:kenguroo/widgets/listview_item.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _fetchAndSet(BuildContext context) async {
      await Provider.of<CafeCategories>(context, listen: false)
          .fetchAndSetCafes(context, false);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Some Address",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1.0,
        leading: IconButton(
            icon: Icon(
              Icons.subdirectory_arrow_right_sharp,
              color: Colors.green,
            ),
            onPressed: () {}),
      ),
      body: FutureBuilder(
        future: _fetchAndSet(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _fetchAndSet(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, top: 20),
                      child: Consumer<CafeCategories>(
                        builder: (context, cafecategories, _) => ListView(
                          shrinkWrap: true,
                          children: [
                            Text(
                              'Акции и Скидки',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 205,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cafecategories.discountCafes.length,
                                itemBuilder: (context, index) =>
                                    ChangeNotifierProvider.value(
                                  value: cafecategories.discountCafes[index],
                                  child: ListViewItem(
                                      cafecategories.discountCafes[index]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 23,
                            ),
                            Text(
                              'Популярные',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 205,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cafecategories.popularCafes.length,
                                itemBuilder: (context, index) =>
                                    ChangeNotifierProvider.value(
                                  value: cafecategories.popularCafes[index],
                                  child: ListViewItem(
                                      cafecategories.popularCafes[index]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 23,
                            ),
                            Text(
                              'Ближайшие',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cafecategories.closestCafes.length,
                                itemBuilder: (context, index) =>
                                    ChangeNotifierProvider.value(
                                  value: cafecategories.closestCafes[index],
                                  child: ListViewItem(
                                      cafecategories.closestCafes[index]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
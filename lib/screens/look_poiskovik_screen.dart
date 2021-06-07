import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenguroo/controllers/poiskovik_controller.dart';
import 'package:kenguroo/models/poiskoviks_data.dart';
import 'package:kenguroo/screens/cafe_detail_screen.dart';

import 'kuhnya_category_screen.dart';

class LookPoiskovikScreen extends StatefulWidget {
  LookPoiskovikScreen({Key key}) : super(key: key);
  static const routeName = '/look-poiskovik-screen';
  @override
  _LookPoiskovikScreenState createState() => _LookPoiskovikScreenState();
}

class _LookPoiskovikScreenState extends State<LookPoiskovikScreen> {
  final PoiskovikController _controller = Get.put(PoiskovikController());
  var _filteredData = <PoiskoviksDataModel>[];
  final _searchController = TextEditingController();
  bool enabled = true;
  var tabIndex = 0;
  void _search() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      if (tabIndex == 0) {
        _filteredData = _controller.dataList
            .where((PoiskoviksDataModel model) =>
                model.restoranTitle.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (tabIndex == 1) {
        _filteredData = _controller.dataList
            .where((model) => model.foods.values.any((element) {
                  return element['title']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }))
            .toList();
      }
    } else {
      _filteredData = _controller.dataList;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _filteredData = _controller.dataList;
    _searchController.addListener(_search);
  }

  @override
  void dispose() {
    _searchController.removeListener(() {
      _search();
    });
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelPadding: EdgeInsets.only(bottom: 10, top: 15),
            indicatorColor: Colors.green,
            tabs: [
              Text(
                'Рестораны',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
              Text(
                'Блюда',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
              Text(
                'Категории',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ],
            onTap: (value) {
              setState(() {
                tabIndex = value;
                if (tabIndex == 2) {
                  enabled = false;
                } else {
                  enabled = true;
                }
              });
            },
          ),
          actions: [
            Container(
              width: (MediaQuery.of(context).size.width - 60),
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  filled: true,
                  fillColor: Colors.white.withAlpha(235),
                  border: InputBorder.none,
                ),
                enabled: enabled,
              ),
            ),
          ],
        ),
        body: TabBarView(children: [
          Obx(
            () => _controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: _filteredData.length,
                      itemBuilder: (context, index) {
                        final restoranId = _filteredData[index].restoranId;
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                CafeDetailScreen.routeName,
                                arguments: restoranId);
                          },
                          title: Text(
                            _filteredData[index].restoranTitle,
                            maxLines: 1,
                          ),
                        );
                      },
                    ),
                  ),
          ),
          Obx(
            () => _controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: _filteredData.length,
                      itemBuilder: (context, index) {
                        final restoranId = _filteredData[index].restoranId;
                        print(_filteredData[index].foods..length);
                        return ListView.builder(
                          physics: const ScrollPhysics(
                              parent: NeverScrollableScrollPhysics()),
                          shrinkWrap: true,
                          itemCount: _filteredData[index].foods.values.length,
                          itemBuilder: (context, i) => _filteredData[index]
                                  .foods
                                  .values
                                  .toList()[i]['title']
                                  .contains(_searchController.text)
                              ? Column(children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          CafeDetailScreen.routeName,
                                          arguments: restoranId);
                                    },
                                    title: Text(
                                      _filteredData[index]
                                          .foods
                                          .values
                                          .toList()[i]['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      maxLines: 3,
                                    ),
                                    leading: Image.network(_filteredData[index]
                                        .foods
                                        .values
                                        .toList()[i]['imageUrl']),
                                    subtitle: Text(
                                      'Стоимость \n ${_filteredData[index].foods.values.toList()[i]['discount']}',
                                      style: TextStyle(
                                          color: Colors.grey, height: 1.5),
                                    ),
                                  ),
                                  Divider()
                                ])
                              : Container(
                                  height: 0,
                                ),
                        );
                      },
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                item('Нациоанальная', context),
                item('Европейская', context),
                item('Бургеры', context),
                item('Донеры', context),
                item('Пицца', context),
                item('Суши', context),
                item('Роллы', context),
                item('Фастфуд', context),
                item('Кофейни', context),
                item('Китайская', context),
                item('Итальянская', context),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget item(String title, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(KuhnyaCategoryScreen.routeName, arguments: title);
      },
      child: ListTile(
        title: Text(
          title,
        ),
      ),
    );
  }
}

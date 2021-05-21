import 'dart:math';

import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:kenguroo/models/searching.dart';
import 'package:kenguroo/providers/search_provider.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import 'cafe_detail_screen.dart';

class LookScreen extends StatefulWidget {
  const LookScreen({Key key}) : super(key: key);

  @override
  _LookScreenState createState() => _LookScreenState();
}

class _LookScreenState extends State<LookScreen> {
  final controller = FloatingSearchBarController();

  int _index = 0;
  int get index => _index;
  set index(int value) {
    _index = min(value, 2);
    _index == 2 ? controller.hide() : controller.show();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildSearchBar(),
    );
  }

  Widget buildSearchBar() {
    final actions = [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.search),
          onPressed: null,
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer<SearchModel>(
      builder: (context, model, _) => FloatingSearchBar(
        automaticallyImplyBackButton: false,
        controller: controller,
        clearQueryOnClose: true,
        hint: 'Ресторан,блюдо или кухня',
        iconColor: Colors.grey,
        transitionDuration: const Duration(milliseconds: 400),
        transitionCurve: Curves.easeInOutCubic,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        actions: actions,
        progress: model.isLoading,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: model.onQueryChanged,
        scrollPadding: EdgeInsets.zero,
        transition: CircularFloatingSearchBarTransition(spacing: 16),
        builder: (context, _) => buildExpandableBody(model, controller.query),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: min(index, 0),
            children: const [
              FloatingSearchAppBarExample(),
            ],
          ),
        ),
        // buildBottomNavigationBar(),
      ],
    );
  }

  Widget buildExpandableBody(SearchModel model, String word) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Material(
        color: Colors.white,
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8),
        child: ImplicitlyAnimatedList<FoodCategory>(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          items: model.suggestions.take(10).toList(),
          areItemsTheSame: (a, b) => a == b,
          itemBuilder: (context, animation, place, i) {
            return SizeFadeTransition(
              animation: animation,
              child: buildItem(context, place, word),
            );
          },
          updateItemBuilder: (context, animation, place) {
            return FadeTransition(
              opacity: animation,
              child: buildItem(context, place, word),
            );
          },
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, FoodCategory place, String word) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final model = Provider.of<SearchModel>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            FloatingSearchBar.of(context).close();
            Future.delayed(
              const Duration(milliseconds: 500),
              () {
                var arguments2 = {
                  place.categories == word ? word : null,
                  place.foods == word ? word : null,
                  place.restourants == word ? word : null
                };
                Navigator.pushNamed(context, CafeDetailScreen.routeName,
                    arguments: arguments2);
              } /*=> model.clear()*/,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: const Icon(Icons.history, key: Key('history'))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word,
                        style: textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (model.suggestions.isNotEmpty && place != model.suggestions.last)
          const Divider(height: 0),
      ],
    );
  }

  // Widget buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     onTap: (value) => index = value,
  //     currentIndex: index,
  //     elevation: 16,
  //     type: BottomNavigationBarType.fixed,
  //     showUnselectedLabels: true,
  //     backgroundColor: Colors.white,
  //     selectedItemColor: Colors.blue,
  //     selectedFontSize: 11.5,
  //     unselectedFontSize: 11.5,
  //     unselectedItemColor: const Color(0xFF4d4d4d),
  //     items: const [
  //       BottomNavigationBarItem(
  //         icon: Icon(MdiIcons.homeVariantOutline),
  //         label: 'Explore',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(MdiIcons.homeCityOutline),
  //         label: 'Commute',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(MdiIcons.homeCityOutline),
  //         label: 'Commute',
  //       ),
  //     ],
  //   );
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class FloatingSearchAppBarExample extends StatelessWidget {
  const FloatingSearchAppBarExample({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 60),
      itemCount: 100,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              child: Row(
                children: [
                  Text(
                    'Item $index',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_right),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ));
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kenguroo/providers/kuhni_provider.dart';
import 'package:kenguroo/widgets/listview_item.dart';
import 'package:provider/provider.dart';

class KuhnyaCategoryScreen extends StatelessWidget {
  static const routeName = '/kuhnya-categories-screen';
  Future<void> _fetch(BuildContext context) async {
    await Provider.of<KuhniProvider>(context, listen: false)
        .fetchAndSetCafesKuhni(context);
  }

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments as String;
    final data = Provider.of<KuhniProvider>(context, listen: false)
        .cafes
        .where(
            (element) => element.chosenKuhni.any((element) => element == title))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: _fetch(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: data[index],
                  child: ListViewItem(data[index]),
                ),
              ),
      ),
    );
  }
}

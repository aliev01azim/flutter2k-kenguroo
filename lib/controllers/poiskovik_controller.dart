import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:kenguroo/models/poiskoviks_data.dart';

class PoiskovikController extends GetxController {
  var isLoading = false.obs;
  var dataList = <PoiskoviksDataModel>[].obs;
  @override
  void onInit() {
    fetchAllData();
    super.onInit();
  }

  Future<void> fetchAllData() async {
    isLoading(true);
    var url = Uri.parse(
        'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes.json');
    try {
      final response = await get(url);
      final restoranData = json.decode(response.body) as Map<String, dynamic>;
      if (restoranData == null) {
        return;
      }

      final List<PoiskoviksDataModel> loadedProducts = [];
      restoranData.forEach((prodId, prodData) {
        loadedProducts.add(PoiskoviksDataModel(
            restoranId: prodId,
            restoranTitle: prodData['title'],
            foods: prodData['foods']));
      });

      dataList.value = loadedProducts;
    } finally {
      isLoading(false);
    }
  }
}

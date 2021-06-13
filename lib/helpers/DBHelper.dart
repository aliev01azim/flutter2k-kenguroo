import 'package:hive/hive.dart';

class DBHelper {
  static Future openBox(String boxname) async {
    await Hive.openBox(boxname);
    return;
  }

  static Future getData(boxname) async {
    final box = await Hive.openBox(boxname);
    return box.values;
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:patrol_application/util/log.dart';

class StoreOnDevice {
  late SharedPreferences sharedPrefs;
  Future<void> init() async {
    sharedPrefs = await SharedPreferences.getInstance();
    Log().i(sharedPrefs.getKeys().toString());
  }

  Future<void> storeList({required String key, required List<String> args}) async {
    await sharedPrefs.setStringList(key, args);
  }

  List<String>? getListByKey({required String key}) {
    return sharedPrefs.getStringList(key);
  }

  void deleteByKey(String key) {
    sharedPrefs.remove(key);
  }
}

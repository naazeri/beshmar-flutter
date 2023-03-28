import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _dataKey = 'data';

  static Future<bool> saveData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_dataKey, data);
  }

  static Future<String?> readData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dataKey);
  }

  void remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

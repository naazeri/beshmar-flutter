import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _dataKey = 'data';
  static const _showcaseKey = 'showcase_seen';
  static const _iabKey = 'iab';

  static Future<bool> setData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_dataKey, data);
  }

  static Future<String?> getData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dataKey);
  }

  static Future<bool> setShowcaseStatus(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_showcaseKey, seen);
  }

  static Future<bool> getShowcaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showcaseKey) ?? false;
  }

  static Future<bool> setFullVersionStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_iabKey, value);
  }

  static Future<bool> getFullVersionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_iabKey) ?? false;
  }

  void remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

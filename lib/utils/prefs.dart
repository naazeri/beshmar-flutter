import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _dataKey = 'data';
  static const _showcaseKey = 'showcase_seen';
  static const _iabKey = 'iab';
  static const _countingLockKey = 'c_lock';

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

  static Future<bool> setCountingLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_countingLockKey, value);
  }

  static Future<bool> getCountingLock() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_countingLockKey) ?? false;
  }

  void remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

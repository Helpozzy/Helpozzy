import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static readObject(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get(key) != null) {
      return prefs.get(key);
    } else
      return null;
  }

  static readString(String key) async {
    final value = await readObject(key);
    return value != null ? value : '';
  }

  static readInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get(key) != null) {
      return prefs.get(key);
    } else
      return 0;
  }

  static saveObject(String key, value) async {
    await saveString(key, json.encode(value));
  }

  static saveString(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static saveInt(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

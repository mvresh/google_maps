import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefs{
  read(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString(key));
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    print(json.encode(value));
    prefs.setString(key, json.encode(value));
  }
}
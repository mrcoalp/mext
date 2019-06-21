import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences prefs;

  SharedPrefs();

  Future<String> getString(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int> getInt(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}

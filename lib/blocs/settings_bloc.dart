import 'package:flutter/material.dart';
import 'package:MEXT/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc extends ChangeNotifier {
  ThemeData _theme;
  SharedPreferences _prefs;

  var _lightTheme = new ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    accentColor: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Colors.white,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.teal,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  var _darkTheme = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800],
    accentColor: Colors.teal,
    scaffoldBackgroundColor: Colors.grey[800],
    buttonColor: Colors.grey[800],
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: Colors.grey[800],
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: Colors.grey[800],
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.teal,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  SettingsBloc();

  Future<bool> init() async {
    print('settigs bloc init');
    try {
      _prefs = await SharedPreferences.getInstance();
      if (_prefs.getString(kTheme) == 'dark')
        _theme = _darkTheme;
      else
        _theme = _lightTheme;

      return true;
    } catch (e) {
      return false;
    }
  }

  ThemeData get theme => _theme;

  void setTheme(ThemeMEXT theme) {
    switch (theme) {
      case ThemeMEXT.Light:
        {
          _theme = _lightTheme;
          _prefs.setString(kTheme, 'light');
          break;
        }

      case ThemeMEXT.Dark:
        {
          _theme = _darkTheme;
          _prefs.setString(kTheme, 'dark');
          break;
        }

      default:
        break;
    }

    notifyListeners();
  }
}

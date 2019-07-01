import 'package:flutter/material.dart';
import 'package:MEXT/constants.dart';

class SettingsBloc extends ChangeNotifier {
  ThemeData _theme;

  SettingsBloc() {
    _theme = new ThemeData(
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
  }

  Future<void> init() async {
    //TODO(marco): implement init in shared preferences
  }

  ThemeData get theme => _theme;

  void setTheme(ThemeMEXT theme) {
    switch (theme) {
      case ThemeMEXT.Light:
        _theme = new ThemeData(
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

        break;

      case ThemeMEXT.Dark:
        _theme = new ThemeData(
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

        break;
      default:
        break;
    }

    notifyListeners();
  }
}

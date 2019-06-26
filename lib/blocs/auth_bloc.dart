import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends ChangeNotifier {
  AuthBloc();

  SharedPreferences _prefs;
  int _userId;
  User _user;

  Future<void> init() async {
    print('auth bloc initializing');
    _prefs = await SharedPreferences.getInstance();
    this._userId = _prefs.getInt(kUserId);
  }

  void logout() {
    _userId = null;
    _user = null;
    notifyListeners();
  }

  int get userId => _userId;

  set userId(int id) {
    _userId = id;
    notifyListeners();
  }

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }
}

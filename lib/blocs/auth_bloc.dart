import 'package:MEXT/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends ChangeNotifier {
  int _userId;
  String _token;
  String _refreshToken;
  User _user;

  AuthBloc() {
    this._initOrClear();
  }

  Future<void> _initOrClear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this._userId = prefs.getInt('userId');
    this._token = prefs.getString('token');
    this._refreshToken = prefs.getString('refreshToken');
  }

  void logout() {
    _initOrClear();
    notifyListeners();
  }

  int get userId => _userId;

  set userId(int id) {
    _userId = id;
    notifyListeners();
  }

  String get token => _token;

  set token(String token) {
    _token = token;
    notifyListeners();
  }

  String get refreshToken => _refreshToken;

  set refreshToken(String token) {
    _refreshToken = token;
    notifyListeners();
  }

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }
}

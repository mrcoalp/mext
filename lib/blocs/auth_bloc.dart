import 'package:MEXT/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends ChangeNotifier {
  SharedPreferences _prefs;
  int _userId;
  String _token;
  String _refreshToken;
  User _user;

  AuthBloc() {
    this._init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    this.refreshTokens();
  }

  void refreshTokens() {
    print('refreshing auth tokens...');
    this._userId = _prefs.getInt('userId');
    this._token = _prefs.getString('token');
    this._refreshToken = _prefs.getString('refreshToken');
  }

  void logout() {
    refreshTokens();
    _user = null;
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

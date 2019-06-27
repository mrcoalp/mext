import 'dart:convert';
import 'dart:io';

import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/user.dart';
import 'package:MEXT/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends ChangeNotifier {
  AuthBloc();

  var _userRepository = new UserRepository();

  bool _loading = false;
  String _error = '';

  SharedPreferences _prefs;
  int _userId;
  User _user;

  Future<void> init() async {
    print('auth bloc initializing');
    _prefs = await SharedPreferences.getInstance();
    this._userId = _prefs.getInt(kUserId);

    // if (this._userId != null) await this._getUserDetails(_userId);
  }

  Future<void> getUserDetails(int id) async {
    _loading = true;
    notifyListeners();

    await this._getUserDetails(id);

    _loading = false;
    notifyListeners();
  }

  Future<void> _getUserDetails(int id) async {
    var response = await _userRepository.getUserDetails(id);
    if (response.hasError)
      this._error = response.error;
    else {
      this._error = '';
      imageCache.clear();
      this._user = response.user;
    }
  }

  Future<String> _upload(File image) async {
    _loading = true;
    notifyListeners();

    List<int> imageBytes = await image.readAsBytes();
    print(imageBytes);
    String b64image = base64Encode(imageBytes);

    final _userRepository = new UserRepository();

    final res = await _userRepository.updateProfilePicture(_userId, b64image);

    _loading = false;
    notifyListeners();

    return res;
  }

  Future<String> uploadFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    return await _upload(image);
  }

  Future<String> uploadFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image == null) return null;

    return await _upload(image);
  }

  bool get loading => _loading;

  String get error => _error;

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

  void logout() {
    _userId = null;
    _user = null;
    notifyListeners();
  }
}

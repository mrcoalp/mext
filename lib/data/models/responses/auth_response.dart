import 'package:MEXT/data/models/responses/response.dart';
import 'package:MEXT/data/models/user.dart';
import 'package:flutter/material.dart';

class AuthResponse extends BaseResponse {
  final int userId;
  final String token, refreshToken;
  final User user;
  final String message;

  AuthResponse(
      {@required this.userId,
      @required this.token,
      @required this.refreshToken,
      @required this.user,
      @required this.message,
      String error = '',
      bool hasError = false})
      : super(error, hasError);

  AuthResponse.login(
      {@required this.userId,
      @required this.token,
      @required this.refreshToken,
      String error = '',
      bool hasError = false})
      : this.user = null,
        this.message = null,
        super(error, hasError);

  AuthResponse.register(
      {@required this.user,
      @required this.message,
      String error = '',
      bool hasError = false})
      : this.userId = null,
        this.token = null,
        this.refreshToken = null,
        super(error, hasError);

  AuthResponse.withError(String error, {bool hasError = true})
      : this.userId = null,
        this.token = null,
        this.refreshToken = null,
        this.user = null,
        this.message = null,
        super(error, hasError);
}

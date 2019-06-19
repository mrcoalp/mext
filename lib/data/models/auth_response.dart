import 'package:MEXT/data/models/response.dart';
import 'package:flutter/material.dart';

class AuthResponse extends BaseResponse {
  final int userId;
  final String token, refreshToken;

  AuthResponse(
      {@required this.userId,
      @required this.token,
      @required this.refreshToken,
      String error = '',
      bool hasError = false})
      : super(error, hasError);
  AuthResponse.withError(String error, {bool hasError = false})
      : this.userId = null,
        this.token = null,
        this.refreshToken = null,
        super(error, hasError);
}

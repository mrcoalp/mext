import 'package:MEXT/data/models/responses/response.dart';
import 'package:MEXT/data/models/user.dart';
import 'package:flutter/material.dart';

class UserResponse extends BaseResponse {
  final User user;

  UserResponse({@required this.user, String error = '', bool hasError = false})
      : super(error, hasError);
  UserResponse.withError(String error, {bool hasError = true})
      : this.user = null,
        super(error, hasError);
}

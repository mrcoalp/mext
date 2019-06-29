import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/responses/response.dart';
import 'package:flutter/material.dart';

class UserListsResponse extends BaseResponse {
  final List<Movie> list;
  final String message;

  UserListsResponse({this.list, String error = '', bool hasError = false})
      : this.message = '',
        super(error, hasError);

  UserListsResponse.message(
      {@required this.message, String error = '', bool hasError = false})
      : this.list = [],
        super(error, hasError);
  UserListsResponse.withError(String error, {bool hasError = true})
      : this.list = [],
        this.message = '',
        super(error, hasError);
}

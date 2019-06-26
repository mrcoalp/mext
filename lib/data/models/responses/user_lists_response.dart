import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/responses/response.dart';
import 'package:flutter/material.dart';

class UserListsResponse extends BaseResponse {
  final List<Movie> watched, towatch, favourites;
  final String message;

  UserListsResponse(this.watched, this.towatch, this.favourites, this.message,
      String error, bool hasError)
      : super(error, hasError);
  UserListsResponse.watched(
      {@required this.watched, String error = '', bool hasError = false})
      : this.towatch = [],
        this.favourites = [],
        this.message = '',
        super(error, hasError);
  UserListsResponse.toWatch(
      {@required this.towatch, String error = '', bool hasError = false})
      : this.watched = [],
        this.favourites = [],
        this.message = '',
        super(error, hasError);
  UserListsResponse.favourites(
      {@required this.favourites, String error = '', bool hasError = false})
      : this.towatch = [],
        this.watched = [],
        this.message = '',
        super(error, hasError);
  UserListsResponse.message(
      {@required this.message, String error = '', bool hasError = false})
      : this.towatch = [],
        this.watched = [],
        this.favourites = [],
        super(error, hasError);
  UserListsResponse.withError(String error, {bool hasError = true})
      : this.towatch = [],
        this.watched = [],
        this.favourites = [],
        this.message = '',
        super(error, hasError);
}

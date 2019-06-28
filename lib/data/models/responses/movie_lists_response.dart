import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/responses/response.dart';
import 'package:flutter/material.dart';

class MovieListsResponse extends BaseResponse {
  final List<Movie> list;

  MovieListsResponse(
      {@required this.list, String error = '', bool hasError = false})
      : super(error, hasError);
  MovieListsResponse.withError(String error, {bool hasError = true})
      : this.list = [],
        super(error, hasError);
}

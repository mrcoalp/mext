import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/response.dart';
import 'package:flutter/material.dart';

class RandomMovieResponse extends BaseResponse {
  final Movie movie;

  RandomMovieResponse(
      {String error = '',
      bool hasError = false,
      @required this.movie})
      : super(error, hasError);
  RandomMovieResponse.withError(String error, {bool hasError = true})
      : this.movie = null,
        super(error, hasError);
}

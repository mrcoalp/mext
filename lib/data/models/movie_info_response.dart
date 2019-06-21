import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/movie_info.dart';
import 'package:MEXT/data/models/response.dart';
import 'package:flutter/material.dart';

class MovieInfoResponse extends BaseResponse {
  final MovieInfo movieInfo;

  MovieInfoResponse(
      {@required this.movieInfo, String error = '', bool hasError = false})
      : super(error, hasError);
  MovieInfoResponse.withError(String error, {bool hasError = false})
      : this.movieInfo = null,
        super(error, hasError);
}

class SimilarMoviesResponse extends BaseResponse {
  final List<Movie> similar;

  SimilarMoviesResponse(
      {@required this.similar, String error = '', bool hasError = false})
      : super(error, hasError);
  SimilarMoviesResponse.withError(String error, {bool hasError = false})
      : this.similar = [],
        super(error, hasError);
}

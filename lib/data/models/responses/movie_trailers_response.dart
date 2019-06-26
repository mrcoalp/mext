import 'package:MEXT/data/models/responses/response.dart';
import 'package:flutter/material.dart';

class MovieTrailersResponse extends BaseResponse {
  final List<String> trailers;

  MovieTrailersResponse(
      {@required this.trailers, String error = '', bool hasError = false})
      : super(error, hasError);
  MovieTrailersResponse.withError(String error, {bool hasError = true})
      : this.trailers = [],
        super(error, hasError);
}

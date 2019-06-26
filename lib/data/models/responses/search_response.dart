import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/responses/response.dart';

class SearchResponse extends BaseResponse {
  final List<Movie> movies;
  final int page;
  final int totalPages;

  SearchResponse(
      this.movies, this.page, this.totalPages, String error, bool hasError)
      : super(error, hasError);

  SearchResponse.withError(String error, {bool hasError = true})
      : this.movies = [],
        this.page = 0,
        this.totalPages = 0,
        super(error, hasError);

  factory SearchResponse.fromJson(Map<String, dynamic> json,
      {String error = '', bool hasError = false}) {
    var movies = new List<Movie>();
    for (var m in json['movies']) movies.add(new Movie.fromJson(m));

    return SearchResponse(movies, json['page'] as int,
        json['total_pages'] as int, error, hasError);
  }
}

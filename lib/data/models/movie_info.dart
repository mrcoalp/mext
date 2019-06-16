import 'package:MEXT/data/models/genre.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_info.g.dart';

@JsonSerializable()
class MovieInfo {
  bool adult;
  String backdrop_path;
  int budget;
  List<Genre> genres;
  String homepage;
  int id;
  String imdb_id;
  String original_language;
  String original_title;
  String overview;
  double popularity;
  String poster_path;
  String release_date;
  int revenue;
  int runtime;
  String status;
  String tagline;
  String title;
  bool video;
  double vote_average;
  int vote_count;

  MovieInfo(
      {this.adult,
      this.backdrop_path,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdb_id,
      this.original_language,
      this.original_title,
      this.overview,
      this.popularity,
      this.poster_path,
      this.release_date,
      this.revenue,
      this.runtime,
      this.status,
      this.tagline,
      this.title,
      this.video,
      this.vote_average,
      this.vote_count});

  factory MovieInfo.fromJson(Map<String, dynamic> json) =>
      _$MovieInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MovieInfoToJson(this);
}

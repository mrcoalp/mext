import 'package:MEXT/data/models/genre.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int vote_count;
  final int id;
  final bool video;
  final double vote_average;
  final String title;
  final double popularity;
  final String poster_path;
  final String original_language;
  final String original_title;
  final String backdrop_path;
  final bool adult;
  final String overview;
  final String release_date;
  final List<Genre> genres;

  Movie(
      this.vote_count,
      this.id,
      this.video,
      this.vote_average,
      this.title,
      this.popularity,
      this.poster_path,
      this.original_language,
      this.original_title,
      this.backdrop_path,
      this.adult,
      this.overview,
      this.release_date,
      this.genres);

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

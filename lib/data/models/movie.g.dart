// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
      json['vote_count'] as int,
      json['id'] as int,
      json['video'] as bool,
      (json['vote_average'] as num)?.toDouble(),
      json['title'] as String,
      (json['popularity'] as num)?.toDouble(),
      json['poster_path'] as String,
      json['original_language'] as String,
      json['original_title'] as String,
      json['backdrop_path'] as String,
      json['adult'] as bool,
      json['overview'] as String,
      json['release_date'] as String);
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'vote_count': instance.vote_count,
      'id': instance.id,
      'video': instance.video,
      'vote_average': instance.vote_average,
      'title': instance.title,
      'popularity': instance.popularity,
      'poster_path': instance.poster_path,
      'original_language': instance.original_language,
      'original_title': instance.original_title,
      'backdrop_path': instance.backdrop_path,
      'adult': instance.adult,
      'overview': instance.overview,
      'release_date': instance.release_date
    };

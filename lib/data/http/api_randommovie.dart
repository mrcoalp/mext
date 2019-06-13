import 'dart:convert';

import 'package:http/http.dart' as http;

class APIRandomMovie {
  final String withGenres;
  final String withoutGenres;
  final int rating;
  final int year;
  final int voteCount;
  final bool excludeWatched;

  APIRandomMovie(
      {this.withGenres = '',
      this.withoutGenres = '',
      this.rating = 0,
      this.year = 0,
      this.voteCount = 0,
      this.excludeWatched = false});

  Future getMovieAndGenres() async {
    var json;
    final String uri =
        'http://192.168.3.72/mext/api/randommovie?with_genres=$withGenres&without_genres=$withoutGenres&rating=$rating&year=$year&vote_count=$voteCount&exclude_watched=$excludeWatched';
    print(uri);
    
    try {
      var res = await http.get(uri);
      json = jsonDecode(res.body);
    } catch (e) {
      print(e.toString());
    }

    return json;
  }
}

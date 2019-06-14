import 'dart:convert';

import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:http/http.dart' as http;

class APIGenresList {
  static Future<List<Genre>> getGenres() async {
    var json;
    var genres = new List<Genre>();
    final String uri = '$kAPI_URI/moviegenres';

    try {
      var res = await http.get(uri);
      json = jsonDecode(res.body);
      for (var j in json) genres.add(new Genre.fromJson(j));
    } catch (e) {
      print(e.toString());
    }

    return genres;
  }
}

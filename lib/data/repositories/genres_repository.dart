import 'package:MEXT/.env.dart';
import 'package:MEXT/constants.dart';
import 'package:MEXT/data/models/genre.dart';
import 'package:MEXT/data/web_client.dart';

class GenresRepository {
  final WebClient webClient;

  const GenresRepository({this.webClient = const WebClient()});

  Future<List<Genre>> loadFromTMDB() async {
    var json;
    var genres = new List<Genre>();
    final String uri = '${Config.API_URL}/moviegenres';

    try {
      json = await webClient.get(uri);
      for (var j in json) genres.add(new Genre.fromJson(j));
    } catch (e) {
      print(e.toString());
    }

    return genres;
  }

  List<Genre> loadFromConstants() {
    var genres = new List<Genre>();
    for (var j in lGenres) genres.add(new Genre.fromJson(j));
    return genres;
  }
}

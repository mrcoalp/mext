import 'package:MEXT/.env.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/randommovie_response.dart';
import 'package:MEXT/data/web_client.dart';

class RandomMovieRepository {
  final String withGenres;
  final String withoutGenres;
  final int rating;
  final int year;
  final int voteCount;
  final bool excludeWatched;

  final WebClient webClient;

  RandomMovieRepository(
      {this.withGenres = '',
      this.withoutGenres = '',
      this.rating = 0,
      this.year = 0,
      this.voteCount = 0,
      this.excludeWatched = false,
      this.webClient = const WebClient()});

  Future<RandomMovieResponse> getMovieAndGenres(String token) async {
    var json;
    final String uri =
        '${Config.API_URL}/randommovie?with_genres=$withGenres&without_genres=$withoutGenres&rating=$rating&year=$year&vote_count=$voteCount&exclude_watched=$excludeWatched';
    try {
      json = await webClient.get(uri, token);
      return new RandomMovieResponse(movie: new Movie.fromJson(json));
    } catch (e) {
      print(e.toString());
      return new RandomMovieResponse.withError(e.toString());
    }
  }
}

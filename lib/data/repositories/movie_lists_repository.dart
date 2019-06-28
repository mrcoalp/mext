import 'package:MEXT/.env.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/responses/movie_lists_response.dart';
import 'package:MEXT/data/web_client.dart';

class MovieListsRepository {
  final WebClient webClient;

  MovieListsRepository({this.webClient = const WebClient()});

  Future<MovieListsResponse> getTrending() async {
    String uri = '${Config.API_URL}/movies/trending';
    try {
      var response = await webClient.get(uri);
      var trending = new List<Movie>();
      for (var t in response) trending.add(new Movie.fromJson(t));
      return new MovieListsResponse(list: trending);
    } catch (e) {
      print(e.toString());
      return new MovieListsResponse.withError(e.toString());
    }
  }

  Future<MovieListsResponse> getNowPlaying() async {
    String uri = '${Config.API_URL}/movies/now_playing';
    try {
      var response = await webClient.get(uri);
      var nowPlaying = new List<Movie>();
      for (var t in response) nowPlaying.add(new Movie.fromJson(t));
      return new MovieListsResponse(list: nowPlaying);
    } catch (e) {
      print(e.toString());
      return new MovieListsResponse.withError(e.toString());
    }
  }

  Future<MovieListsResponse> getPopular() async {
    String uri = '${Config.API_URL}/movies/popular';
    try {
      var response = await webClient.get(uri);
      var popular = new List<Movie>();
      for (var t in response) popular.add(new Movie.fromJson(t));
      return new MovieListsResponse(list: popular);
    } catch (e) {
      print(e.toString());
      return new MovieListsResponse.withError(e.toString());
    }
  }

  Future<MovieListsResponse> getUpcoming() async {
    String uri = '${Config.API_URL}/movies/upcoming';
    try {
      var response = await webClient.get(uri);
      var upcoming = new List<Movie>();
      for (var t in response) upcoming.add(new Movie.fromJson(t));
      return new MovieListsResponse(list: upcoming);
    } catch (e) {
      print(e.toString());
      return new MovieListsResponse.withError(e.toString());
    }
  }
}

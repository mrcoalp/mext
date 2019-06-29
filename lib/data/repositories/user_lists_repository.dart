import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/responses/user_lists_response.dart';
import 'package:MEXT/data/web_client.dart';
import 'package:MEXT/.env.dart';

class UserListsRepository {
  final WebClient webClient;

  const UserListsRepository({this.webClient = const WebClient()});

  Future<UserListsResponse> getWatched(int id) async {
    String uri = '${Config.API_URL}/users/$id/watched_movies';
    try {
      final response = await webClient.get(uri);
      var watched = new List<Movie>();
      for (var w in response) watched.add(new Movie.fromJson(w));
      return new UserListsResponse(list: watched);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> addWatched(int id, Movie movie) async {
    String uri = '${Config.API_URL}/users/$id/watched_movies';
    try {
      final response = await webClient.post(uri, movie.toJson());
      return new UserListsResponse.message(
          message: response['message'] as String);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> removeWatched(int id, Movie movie) async {
    String uri = '${Config.API_URL}/users/$id/watched_movies/${movie.id}';
    try {
      final response = await webClient.delete(uri);
      return new UserListsResponse.message(
          message: response['message'] as String);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> getToWatch(int id) async {
    String uri = '${Config.API_URL}/users/$id/towatch_movies';
    try {
      final response = await webClient.get(uri);
      var towatch = new List<Movie>();
      for (var w in response) towatch.add(new Movie.fromJson(w));
      return new UserListsResponse(list: towatch);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> addToWatch(int id, Movie movie) async {
    String uri = '${Config.API_URL}/users/$id/towatch_movies';
    try {
      final response = await webClient.post(uri, movie.toJson());
      return new UserListsResponse.message(
          message: response['message'] as String);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> removeToWatch(int id, Movie movie) async {
    String uri = '${Config.API_URL}/users/$id/towatch_movies/${movie.id}';
    try {
      final response = await webClient.delete(uri);
      return new UserListsResponse.message(
          message: response['message'] as String);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> getFavourites(int id) async {
    String uri = '${Config.API_URL}/users/$id/favourite_movies';
    try {
      final response = await webClient.get(uri);
      var favourites = new List<Movie>();
      for (var w in response) favourites.add(new Movie.fromJson(w));
      return new UserListsResponse(list: favourites);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> addFavourites(int id, Movie movie) async {
    String uri = '${Config.API_URL}/users/$id/favourite_movies';
    try {
      final response = await webClient.post(uri, movie.toJson());
      return new UserListsResponse.message(
          message: response['message'] as String);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> removeFavourites(int id, Movie movie) async {
    String uri = '${Config.API_URL}/users/$id/favourite_movies/${movie.id}';
    try {
      final response = await webClient.delete(uri);
      return new UserListsResponse.message(
          message: response['message'] as String);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }

  Future<UserListsResponse> getSuggested(int id) async {
    String uri = '${Config.API_URL}/users/$id/suggested_movies';
    try {
      final response = await webClient.get(uri);
      var suggested = new List<Movie>();
      for (var w in response) suggested.add(new Movie.fromJson(w));
      return new UserListsResponse(list: suggested);
    } catch (e) {
      print(e.toString());
      return new UserListsResponse.withError(e.toString());
    }
  }
}

import 'package:MEXT/.env.dart';
import 'package:MEXT/data/models/movie.dart';
import 'package:MEXT/data/models/movie_info.dart';
import 'package:MEXT/data/models/movie_info_response.dart';
import 'package:MEXT/data/models/movie_trailers_response.dart';
import 'package:MEXT/data/web_client.dart';

class MovieDetailsRepository {
  final WebClient webClient;

  const MovieDetailsRepository({this.webClient = const WebClient()});

  Future<MovieTrailersResponse> getTrailers(int id) async {
    String uri = '${Config.API_URL}/movies/$id/trailers';
    try {
      var response = await webClient.get(uri);
      var trailers = new List<String>();
      for (var t in response) trailers.add(t.toString());
      return new MovieTrailersResponse(trailers: trailers);
    } catch (e) {
      print(e.toString());
      return new MovieTrailersResponse.withError(e.toString());
    }
  }

  Future<MovieInfoResponse> getMoreInfo(int id) async {
    String uri = '${Config.API_URL}/movies/$id/more_info';
    try {
      var response = await webClient.get(uri);
      return new MovieInfoResponse(movieInfo: new MovieInfo.fromJson(response));
    } catch (e) {
      print(e.toString());
      return new MovieInfoResponse.withError(e.toString());
    }
  }

  Future<SimilarMoviesResponse> getSimilar(int id) async {
    String uri = '${Config.API_URL}/movies/$id/similar';
    try {
      var response = await webClient.get(uri);
      var similar = new List<Movie>();
      for (var m in response) {
        similar.add(new Movie.fromJson(m));
      }

      return new SimilarMoviesResponse(similar: similar);
    } catch (e) {
      print(e.toString());
      return new SimilarMoviesResponse.withError(e.toString());
    }
  }
}

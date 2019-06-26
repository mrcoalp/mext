import 'package:MEXT/data/models/responses/search_response.dart';
import 'package:MEXT/data/web_client.dart';
import 'package:MEXT/.env.dart';

class SearchRepository {
  final WebClient webClient;

  SearchRepository({this.webClient = const WebClient()});

  Future<SearchResponse> search(String query, int page) async {
    String uri = '${Config.API_URL}/movies/search?query=$query&page=$page';
    try {
      var response = await webClient.get(uri);
      return new SearchResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      return new SearchResponse.withError(e.toString());
    }
  }
}

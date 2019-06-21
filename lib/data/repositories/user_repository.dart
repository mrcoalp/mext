import 'package:MEXT/data/models/user.dart';
import 'package:MEXT/data/models/user_response.dart';
import 'package:MEXT/data/web_client.dart';
import 'package:MEXT/.env.dart';

class UserRepository {
  final WebClient webClient;

  UserRepository({this.webClient = const WebClient()});

  Future<UserResponse> getUserDetails(int id, String token) async {
    String uri = '${Config.API_URL}/users/$id';
    try {
      var response = await webClient.get(uri, token);
      return new UserResponse(user: new User.fromJson(response));
    } catch (e) {
      print(e.toString());
      return new UserResponse.withError(e.toString());
    }
  }

  Future<String> updateProfilePicture(
      int id, String token, String b64image) async {
    String uri = '${Config.API_URL}/users/$id/profilepicture';
    try {
      var response = await webClient.post(uri, b64image, token);
      return response['message'] as String;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}

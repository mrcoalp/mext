import 'package:MEXT/.env.dart';
import 'package:MEXT/data/models/auth_response.dart';
import 'package:MEXT/data/web_client.dart';

class AuthRepository {
  final WebClient webClient;

  const AuthRepository({this.webClient = const WebClient()});

  Future<AuthResponse> login(String username, String password) async {
    String uri = '${Config.API_URL}/login';
    Map<String, dynamic> body = {
      'username': username,
      'password': password,
    };

    try {
      var response = await webClient.post(uri, body);
      return new AuthResponse(
          userId: response['user_id'] as int,
          token: response['token'] as String,
          refreshToken: response['refreshToken'] as String);
    } catch (e) {
      print(e.toString());
      return new AuthResponse.withError(e.toString());
    }
  }
}

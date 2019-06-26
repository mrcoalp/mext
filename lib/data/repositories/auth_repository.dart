import 'package:MEXT/.env.dart';
import 'package:MEXT/data/models/responses/auth_response.dart';
import 'package:MEXT/data/models/user.dart';
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
      return new AuthResponse.login(
          userId: response['user_id'] as int,
          token: response['token'] as String,
          refreshToken: response['refreshToken'] as String);
    } catch (e) {
      print(e.toString());
      return new AuthResponse.withError(e.toString());
    }
  }

  Future<AuthResponse> register(
      String name, String username, String email, String password) async {
    String uri = '${Config.API_URL}/register';
    Map<String, dynamic> body = {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };

    try {
      var response = await webClient.post(uri, body);
      return new AuthResponse.register(
          message: response['message'] as String,
          user: new User.fromJson(
            response['user'],
          ));
    } catch (e) {
      print(e.toString());
      return new AuthResponse.withError(e.toString());
    }
  }
}

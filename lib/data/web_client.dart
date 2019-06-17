import 'dart:convert';

import 'package:http/http.dart' as http;

class WebClient {
  const WebClient();

  _refreshToken(String token) {}

  String _handleError(http.Response res, String token) {
    if (res.body.contains('DOCTYPE html')) {
      return '${res.statusCode}: something went wrong';
    }

    if (res.statusCode == 401 && res.headers['algo'] == 'algo')
      _refreshToken(token);

    try {
      final json = jsonDecode(res.body);
      String message = 'message: ${res.statusCode}: ${json['message']}';
      message += json['error'] != null ? ', error: ${json['error']}' : '';

      return message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> get(String url, [String token]) async {
    print('GET $url TOKEN $token');

    final http.Response res = await http.get(url);

    print('code: ${res.statusCode}\nheaders: ${res.headers}\nres: ${res.body}');

    if (res.statusCode >= 400) {
      throw _handleError(res, token);
    }

    return jsonDecode(res.body);
  }

  Future<dynamic> post(String url, dynamic body, [String token]) async {
    print('GET $url TOKEN $token');

    final http.Response res = await http.post(url, body: body);

    print('code: ${res.statusCode}\nheaders: ${res.headers}\nres: ${res.body}');

    if (res.statusCode >= 400) {
      throw _handleError(res, token);
    }

    return jsonDecode(res.body);
  }
}

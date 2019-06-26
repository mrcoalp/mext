import 'dart:convert';

import 'package:MEXT/constants.dart';
import 'package:http/http.dart' as http;
import 'package:MEXT/.env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebClient {
  const WebClient();

  Future<dynamic> refreshToken(String url, String token, Function method,
      [dynamic body]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String refreshToken = prefs.getString(kRefreshToken);

    String uri = '${Config.API_URL}/refreshtoken';

    try {
      final newTokenRes =
          await post(uri, {'token': token, 'refreshToken': refreshToken});

      await prefs.setString(
          kRefreshToken, newTokenRes['refreshToken'] as String);
      await prefs.setString(kToken, newTokenRes['token'] as String);

      if (method == get)
        return await get(url);
      else if (method == post)
        return await post(url, body);
      else if (method == delete) return await delete(url);
    } catch (e) {
      throw e.toString();
    }
  }

  String _handleError(http.Response res) {
    try {
      if (res.statusCode == 500) {
        return '${res.statusCode}: something went wrong';
      }

      final json = jsonDecode(res.body);
      String message = 'message: ${res.statusCode}: ${json['message']}';
      message += json['error'] != null ? ', error: ${json['error']}' : '';

      return message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> get(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(kToken);

    print('GET $url TOKEN $token');

    var headers = token != null
        ? {"Authorization": "Bearer $token", "Content-Type": "application/json"}
        : {"Content-Type": "application/json"};

    final http.Response res = await http.get(url, headers: headers);

    print('code: ${res.statusCode}\nheaders: ${res.headers}\nres: ${res.body}');

    if (res.statusCode == 401 && res.headers['token-expired'] == 'true')
      return await refreshToken(url, token, get);

    if (res.statusCode >= 400) {
      throw _handleError(res);
    }

    return jsonDecode(res.body);
  }

  Future<dynamic> post(String url, dynamic body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(kToken);

    print('POST $url TOKEN $token BODY ${jsonEncode(body)}');

    var headers = token != null
        ? {"Authorization": "Bearer $token", "Content-Type": "application/json"}
        : {"Content-Type": "application/json"};

    final http.Response res =
        await http.post(url, body: jsonEncode(body), headers: headers);

    print('code: ${res.statusCode}\nheaders: ${res.headers}\nres: ${res.body}');

    if (res.statusCode == 401 && res.headers['token-expired'] == 'true')
      return await refreshToken(url, token, post, body);

    if (res.statusCode >= 400) {
      throw _handleError(res);
    }

    return jsonDecode(res.body);
  }

  Future<dynamic> delete(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(kToken);

    print('DELETE $url TOKEN $token');

    var headers = token != null
        ? {"Authorization": "Bearer $token", "Content-Type": "application/json"}
        : {"Content-Type": "application/json"};

    final http.Response res = await http.delete(url, headers: headers);

    print('code: ${res.statusCode}\nheaders: ${res.headers}\nres: ${res.body}');

    if (res.statusCode == 401 && res.headers['token-expired'] == 'true')
      return await refreshToken(url, token, delete);

    if (res.statusCode >= 400) {
      throw _handleError(res);
    }

    return jsonDecode(res.body);
  }
}

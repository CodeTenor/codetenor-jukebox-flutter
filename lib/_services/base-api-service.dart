import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseApiService {
  // Singleton implementation
  static BaseApiService _instance = new BaseApiService.internal();
  BaseApiService.internal();
  factory BaseApiService() => _instance;
  String identityToken;

  final JsonDecoder jsonDecoder = new JsonDecoder();

  Map<String, String> headers(bool identityTokenHeader) {
    if (identityTokenHeader) {
      var headers = {
        'Content-Type': 'application/json',
        'IdentityToken': identityToken
      };
      return headers;
    } else {
      var headers = {'Content-Type': 'application/json'};
      return headers;
    }
  }

  Future<dynamic> getResponse(String url) async {
    print('get request: ' + url);

    var getHeaders = headers(false);
    var response = await http.get(url, headers: getHeaders);

    return jsonDecoder.convert(response.body);
  }

  Future<dynamic> post(
      dynamic body, String url, bool identityTokenHeader) async {
    print('post request: ' + url);

    var getHeaders = headers(identityTokenHeader);

    var response = await http.post(url,
        body: jsonEncode(body), headers: getHeaders);

    // Check for Identity Token
    if (response.headers.containsKey('identitytoken')) {
      identityToken = response.headers['identitytoken'];
    }
    return jsonDecoder.convert(response.body);
  }
}
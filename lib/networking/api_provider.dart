import 'dart:convert';

import 'package:http/http.dart';

import 'networking_exceptions.dart';
import 'nothing.dart';
import 'request_type.dart';

class ApiProvider {
  final String _baseUrl; // = "https://api.chucknorris.io";

  final Client _client;

  ApiProvider()
      : _client = Client(),
        _baseUrl = "https://api.chucknorris.io";

  Future<dynamic> request({
    required RequestType requestType,
    required String path,
    dynamic parameters = Nothing,
    Map<String, String> headers = const {},
  }) async {
    final request = _RequestModel(
      requestType: requestType,
      path: path,
      parameters: parameters,
      headers: headers,
    );

    final response = await _performRequest(request);
    final responseBody = await _handleResponse(response);
    print(responseBody);

    return responseBody;
  }

  /// Perform request based on request type
  ///
  Future<Response> _performRequest(_RequestModel request) async {
    switch (request.requestType) {
      case RequestType.GET:
        return get(request);
      case RequestType.POST:
        return post(request);
      case RequestType.PUT:
        return put(request);
      case RequestType.DELETE:
        return delete(request);
    }
  }

  Future<dynamic> _handleResponse(Response response) async {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body.toString());
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<Response> get(_RequestModel request) => _client.get(
        _fullUrl(request.path),
        headers: _headers(request.headers),
      );

  Future<Response> post(_RequestModel request) => _client.post(
        _fullUrl(request.path),
        headers: _headers(request.headers),
        body: json.encode(request.parameters),
      );

  Future<Response> put(_RequestModel request) => _client.put(
        _fullUrl(request.path),
        headers: _headers(request.headers),
        body: json.encode(request.parameters),
      );

  Future<Response> delete(_RequestModel request) => _client.delete(
        _fullUrl(request.path),
        headers: _headers(request.headers),
        body: json.encode(request.parameters),
      );

  /// Returns full path with query
  ///
  Uri _fullUrl(String path) => Uri.parse(
        '$_baseUrl/$path',
      );

  /// Final headers (Common + Additional)
  ///
  Map<String, String> _headers(Map<String, String> additionalHeaders) => {
        ..._commonHeaders(),
        ...additionalHeaders,
      };

  /// Common headers
  ///
  Map<String, String> _commonHeaders() => {
        "Content-Type": "application/json",
      };
}

class _RequestModel {
  RequestType requestType;
  String path;
  dynamic parameters = Nothing;
  Map<String, String> headers;

  _RequestModel({
    required this.requestType,
    required this.path,
    this.parameters = Nothing,
    this.headers = const {},
  });
}

import 'dart:convert';

import 'package:http/http.dart';

import 'networking_exceptions.dart';
import 'request_type.dart';

class ApiProvider {
  final String _baseUrl;

  final Client _client;

  ApiProvider()
      : _client = Client(),
        _baseUrl = "https://api.chucknorris.io";

  /// Perform api request. Return dynamic type of response or throws an error if any.
  ///
  Future<dynamic> request({
    required RequestType requestType,
    required String path,
    dynamic parameters = const {},
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
        return _get(request);
      case RequestType.POST:
        return _post(request);
      case RequestType.PUT:
        return _put(request);
      case RequestType.DELETE:
        return _delete(request);
    }
  }

  /// Handle incoming http response based on status code
  ///
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

  /// Perform get request with `RequestModel`
  ///
  Future<Response> _get(_RequestModel request) => _client.get(
        _fullUrl(request.path),
        headers: _headers(request.headers),
      );

  /// Perform post request with `RequestModel`
  ///
  Future<Response> _post(_RequestModel request) => _client.post(
        _fullUrl(request.path),
        headers: _headers(request.headers),
        body: json.encode(request.parameters),
      );

  /// Perform put request with `RequestModel`
  ///
  Future<Response> _put(_RequestModel request) => _client.put(
        _fullUrl(request.path),
        headers: _headers(request.headers),
        body: json.encode(request.parameters),
      );

  /// Perform delete request with `RequestModel`
  ///
  Future<Response> _delete(_RequestModel request) => _client.delete(
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

/// Combination of request data
///
class _RequestModel {
  RequestType requestType;
  String path;
  dynamic parameters;
  Map<String, String> headers;

  _RequestModel({
    required this.requestType,
    required this.path,
    this.parameters,
    this.headers = const {},
  });
}

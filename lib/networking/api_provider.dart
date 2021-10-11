import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'endpoint.dart';
import 'networking_exceptions.dart';
import 'request_type.dart';

class ApiProvider {
  final String _baseUrl;
  final http.Client _client;

  ApiProvider({
    required String baseUrl,
    http.Client? client,
  })  : this._client = client ?? http.Client(),
        this._baseUrl = baseUrl;

  /// Perform api request. Return dynamic type of response or throws an error if any.
  ///
  Future<dynamic> request({
    required RequestType requestType,
    required String path,
    dynamic parameters = const {},
    Map<String, String> headers = const {},
  }) async {
    final endpoint = Endpoint(
      baseUrl: _baseUrl,
      path: path,
      requestType: requestType,
      parameters: parameters,
      headers: _createHeaders(headers),
    );

    return await _requestWithLogger(endpoint);
  }

  /// Perform request with logging
  ///
  Future<dynamic> _requestWithLogger(Endpoint endpoint) async {
    try {
      _log('📝', 'Networking Request: ${endpoint.fullUrl}');
      final responseBody = await _request(endpoint);
      _log('🈯', 'Networking Response: ${endpoint.fullUrl} \n$responseBody');
      return responseBody;
    } catch (error) {
      _log('⛔️', 'Networking Error: $error');
      throw error;
    }
  }

  /// Perform request with request model
  ///
  Future<dynamic> _request(Endpoint request) async {
    try {
      final response = await _performRequest(request);
      return await _handleResponse(response);
    } on SocketException catch (error) {
      throw FetchDataException('Internet connection issue');
    }
  }

  /// Perform request based on request type
  ///
  Future<http.Response> _performRequest(Endpoint request) async {
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
  Future<dynamic> _handleResponse(http.Response response) async {
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
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  /// Perform get request with `RequestModel`
  ///
  Future<http.Response> _get(Endpoint endpoint) => _client.get(
        endpoint.fullUrl,
        headers: endpoint.headers,
      );

  /// Perform post request with `RequestModel`
  ///
  Future<http.Response> _post(Endpoint endpoint) => _client.post(
        endpoint.fullUrl,
        headers: endpoint.headers,
        body: json.encode(endpoint.parameters),
      );

  /// Perform put request with `RequestModel`
  ///
  Future<http.Response> _put(Endpoint endpoint) => _client.put(
        endpoint.fullUrl,
        headers: endpoint.headers,
        body: json.encode(endpoint.parameters),
      );

  /// Perform delete request with `RequestModel`
  ///
  Future<http.Response> _delete(Endpoint endpoint) => _client.delete(
        endpoint.fullUrl,
        headers: endpoint.headers,
        body: json.encode(endpoint.parameters),
      );

  /// Common headers
  ///
  Map<String, String> _commonHeaders() => {
        "Content-Type": "application/json",
      };

  /// Final headers (Common + Additional)
  ///
  Map<String, String> _createHeaders(Map<String, String> additionalHeaders) => {
        ..._commonHeaders(),
        ...additionalHeaders,
      };

  /// Log networking message with prefix string, mostly an icon
  ///
  void _log(String prefix, dynamic message) {
    print('$prefix [${DateTime.now()}] $message');
  }
}

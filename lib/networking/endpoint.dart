import 'request_type.dart';

/// Combination of request data
///
class Endpoint {
  RequestType requestType;
  String _baseUrl;
  String _path;
  dynamic parameters;
  Map<String, String> headers;

  Endpoint({
    required String baseUrl,
    required String path,
    required RequestType requestType,
    this.parameters,
    this.headers = const {},
  })  : this._baseUrl = baseUrl,
        this._path = path,
        this.requestType = requestType;

  /// Returns full path with query
  ///
  Uri get fullUrl => Uri.parse(
        '$_baseUrl/$_path',
      );
}

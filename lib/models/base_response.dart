/// Base API Reponse
/// Added for testing purposes only.
///
class BaseResponse<T> {
  int statusCode;
  String statusMessage;
  T data;

  BaseResponse({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return BaseResponse<T>(
      statusCode: json["code"],
      statusMessage: json["message"],
      data: create(json["data"]),
    );
  }
}

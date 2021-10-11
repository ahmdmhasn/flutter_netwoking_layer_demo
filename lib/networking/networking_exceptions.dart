class NetworkingException implements Exception {
  final _message;
  final _prefix;

  NetworkingException([
    this._prefix,
    this._message,
  ]);

  String toString() {
    return "${_prefix ?? ''}${_message ?? ''}";
  }
}

class FetchDataException extends NetworkingException {
  FetchDataException([
    String? message,
  ]) : super(
          "Error During Communication: ",
          message,
        );
}

class BadRequestException extends NetworkingException {
  BadRequestException([
    String? message,
  ]) : super(
          "Invalid Request: ",
          message,
        );
}

class UnauthorisedException extends NetworkingException {
  UnauthorisedException([
    String? message,
  ]) : super(
          "Unauthorised: ",
          message,
        );
}

class InvalidInputException extends NetworkingException {
  InvalidInputException([
    String? message,
  ]) : super(
          "Invalid Input: ",
          message,
        );
}

class EmptyListException extends NetworkingException {
  EmptyListException([
    String? message,
  ]) : super(
          "Empty List",
          message,
        );
}

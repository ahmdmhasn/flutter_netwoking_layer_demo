class Response<T> {
  Status status;
  T? data;
  String? message;

  Response({
    required this.status,
    this.data,
    this.message,
  });

  Response.loading({this.message = 'Loading'}) : status = Status.LOADING;
  Response.completed(this.data) : status = Status.COMPLETED;
  Response.error(this.message) : status = Status.ERROR;
}

enum Status { LOADING, COMPLETED, ERROR }

class Status<T> {
  StatusType status;
  T? data;
  String? message;

  Status({
    required this.status,
    this.data,
    this.message,
  });

  Status.loading({this.message = 'Loading'}) : status = StatusType.LOADING;
  Status.completed(this.data) : status = StatusType.COMPLETED;
  Status.error(this.message) : status = StatusType.ERROR;
  Status.initial() : status = StatusType.COMPLETED;
}

enum StatusType { LOADING, COMPLETED, ERROR }

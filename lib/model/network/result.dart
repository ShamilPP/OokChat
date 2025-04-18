enum ResultStatus { idle, loading, success, failed }

class Result<T> {
  final ResultStatus status;
  final T? data;
  final String? message;

  bool get isSuccess => status == ResultStatus.success;

  const Result._({
    required this.status,
    this.data,
    this.message,
  });

  const Result.initial() : this._(status: ResultStatus.idle);

  const Result.loading() : this._(status: ResultStatus.loading);

  const Result.success(T data, {String? message}) : this._(status: ResultStatus.success, data: data, message: message);

  const Result.error(String message) : this._(status: ResultStatus.failed, message: message);

  @override
  String toString() => "Status: $status, Message: $message, Data: $data";
}

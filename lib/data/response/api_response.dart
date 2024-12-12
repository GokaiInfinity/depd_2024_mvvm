import 'package:depd_2024_mvvm/data/response/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse({this.status, this.data, this.message});

  ApiResponse.notStarted() : status = Status.notStarted;
  ApiResponse.error(this.message) : status = Status.error;
  ApiResponse.completed(this.data) : status = Status.completed;
  ApiResponse.loading() : status = Status.loading;

  @override
  String toString() {
    return "Status : $status \nMessage : $message \nData : $data";
  }
}

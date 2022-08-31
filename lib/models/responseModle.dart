// ignore_for_file: file_names

class ResponseModel<T> {
  int? status;
  String? message;
  T? data;
  ResponseModel({this.status, this.data, this.message});
}

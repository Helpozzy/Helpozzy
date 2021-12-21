class ResponseModel {
  bool? success;
  String? message;
  String? error;

  ResponseModel({
    this.success = false,
    this.message = '',
    this.error = '',
  });
}

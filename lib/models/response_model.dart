class ResponseModel {
  bool? success;
  String? message;
  String? error;
  dynamic returnValue;

  ResponseModel({
    this.success = false,
    this.message = '',
    this.error = '',
    this.returnValue,
  });
}

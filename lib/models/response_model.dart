class ResponseModel {
  bool? status;
  String? message;
  String? error;
  dynamic returnValue;

  ResponseModel({
    this.status = false,
    this.message = '',
    this.error = '',
    this.returnValue,
  });
}

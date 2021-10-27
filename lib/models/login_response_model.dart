import 'package:firebase_auth/firebase_auth.dart';

class LoginResponseModel {
  User? user;
  String? type;
  bool? success;
  String? message;
  String? error;

  LoginResponseModel({
    this.user,
    this.type,
    this.success = false,
    this.message = '',
    this.error = '',
  });
}

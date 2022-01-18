import 'package:firebase_auth/firebase_auth.dart';

class LoginResponseModel {
  User? user;
  bool? success;
  String? message;
  String? error;

  LoginResponseModel({
    this.user,
    this.success = false,
    this.message = '',
    this.error = '',
  });
}

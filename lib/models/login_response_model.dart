import 'package:firebase_auth/firebase_auth.dart';

class AuthResponseModel {
  User? user;
  bool? success;
  String? message;
  String? error;

  AuthResponseModel({
    this.user,
    this.success = false,
    this.message = '',
    this.error = '',
  });
}

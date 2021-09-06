import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isLoading;

  LoginState({
    this.email = "",
    this.password = "",
    this.isLoading = false,
  });

  @override
  List<Object> get props => [
        email,
        password,
        isLoading,
      ];

  LoginState copyWith(
    LoginState oldState, {
    email,
    password,
    isLoading,
  }) {
    return LoginState(
      email: email ?? oldState.email,
      password: password ?? oldState.password,
      isLoading: isLoading ?? oldState.isLoading,
    );
  }

  LoginState reset() {
    return LoginState(
      email: "",
      password: "",
    );
  }
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucceed extends LoginState {
  final User user;
  LoginSucceed({required this.user});
}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed({required this.message});
}

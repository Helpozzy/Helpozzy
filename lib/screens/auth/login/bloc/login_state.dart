import 'package:equatable/equatable.dart';
import 'package:helpozzy/models/login_response_model.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isLoading;

  LoginState({
    this.email = '',
    this.password = '',
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
    type,
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
      email: '',
      password: '',
    );
  }
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucceed extends LoginState {
  final LoginResponseModel loginResponse;
  LoginSucceed({required this.loginResponse});
}

class LoginFailed extends LoginState {
  final LoginResponseModel loginResponse;
  LoginFailed({required this.loginResponse});
}

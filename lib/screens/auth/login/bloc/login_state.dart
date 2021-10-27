import 'package:equatable/equatable.dart';
import 'package:helpozzy/models/login_response_model.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isLoading;
  final String type;

  LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.type = '',
  });

  @override
  List<Object> get props => [
        email,
        password,
        type,
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
      type: type ?? oldState.type,
      isLoading: isLoading ?? oldState.isLoading,
    );
  }

  LoginState reset() {
    return LoginState(
      email: '',
      password: '',
      type: '',
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

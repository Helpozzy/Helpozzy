part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthenticateState extends AuthState {
  final LoginResponseModel authResponse;
  AuthenticateState({required this.authResponse});
}

class UnAuthenticateState extends AuthState {}

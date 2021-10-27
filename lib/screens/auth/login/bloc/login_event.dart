import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  List<Object> get props => [password];
}

class LoginTypeChanged extends LoginEvent {
  const LoginTypeChanged(this.type);

  final String type;

  List<Object> get props => [type];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

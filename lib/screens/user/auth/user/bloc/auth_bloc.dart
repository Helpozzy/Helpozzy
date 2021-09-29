import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:helpozzy/screens/user/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;
  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial()) {
    add(AppLoaded());
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppLoaded) {
      await Future.delayed(Duration(seconds: 3));
      try {
        var isSignedIn = await authRepository.isSignedIn();

        if (isSignedIn) {
          var user = await authRepository.getCurrentUser();
          if (user != null) yield AuthenticateState(user: user);
        } else {
          yield UnAuthenticateState();
        }
      } catch (e) {
        yield UnAuthenticateState();
      }
    } else if (event is AppLogout) {
      await authRepository.signOut();
    }
  }
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:helpozzy/firebase_repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:helpozzy/models/login_response_model.dart';

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
          final LoginResponseModel? authResponse =
              await authRepository.getCurrentUser();
          if (authResponse!.user != null)
            yield AuthenticateState(authResponse: authResponse);
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

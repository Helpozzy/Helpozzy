import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/screens/auth/auth_repository.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_event.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_state.dart';
import 'package:helpozzy/utils/constants.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var loginBloc;
  AuthRepository authRepository;
  LoginBloc({this.loginBloc, required this.authRepository})
      : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // Email updated
    if (event is LoginEmailChanged) {
      yield _mapEmailChangedToState(event, state);
      // Password updated
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      final email = state.email;
      final password = state.password;
      print('EmailID: $email');
      print('Password: $password');
      // call api
      yield state.copyWith(state, isLoading: true);
      var user = await authRepository.signIn(email, password);
      if (user != null && user is User) {
        prefsObject.setString('uID', user.uid);
        yield LoginSucceed(user: user);
      } else {
        yield LoginFailed(message: user.toString());
      }
    }
  }

  LoginState _mapEmailChangedToState(
    LoginEmailChanged event,
    LoginState state,
  ) {
    return state.copyWith(state, email: event.email);
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    return state.copyWith(state, password: event.password);
  }
}

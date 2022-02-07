import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/firebase_repository/auth_repository.dart';
import 'package:helpozzy/models/login_response_model.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_event.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_state.dart';
import 'package:helpozzy/utils/constants.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var loginBloc;
  AuthRepository authRepository;
  LoginBloc({this.loginBloc, required this.authRepository})
      : super(LoginState());

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      final email = state.email;
      final password = state.password;
      yield state.copyWith(state, isLoading: true);
      LoginResponseModel loginResponse =
          await authRepository.signIn(email, password);
      if (loginResponse.user != null) {
        prefsObject.setString(CURRENT_USER_ID, loginResponse.user!.uid);
        yield LoginSucceed(loginResponse: loginResponse);
      } else {
        yield LoginFailed(loginResponse: loginResponse);
      }
    }
  }

  LoginState _mapEmailChangedToState(
      LoginEmailChanged event, LoginState state) {
    return state.copyWith(state, email: event.email);
  }

  LoginState _mapPasswordChangedToState(
      LoginPasswordChanged event, LoginState state) {
    return state.copyWith(state, password: event.password);
  }
}

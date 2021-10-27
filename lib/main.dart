import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/app.dart';
import 'package:helpozzy/firebase_repository/auth_repository.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/user/home/bloc/home_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefsObject = prefs;
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => LoginBloc(
          authRepository: AuthRepository(),
        ),
      ),
      BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository())),
      BlocProvider(
        create: (_) => HomeBloc(),
      ),
    ], child: HelpozzyApp()),
  );
}

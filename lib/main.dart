import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/app.dart';
import 'package:helpozzy/screens/auth/auth_repository.dart';
import 'package:helpozzy/screens/auth/login/bloc/login_bloc.dart';
import 'package:helpozzy/screens/auth/user/bloc/auth_bloc.dart';
import 'package:helpozzy/screens/home/bloc/bloc/home_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
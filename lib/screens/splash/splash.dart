import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthenticateState) {
          if (state.authResponse.type == LOGIN_ADMIN) {
            Navigator.pushNamedAndRemoveUntil(
                context, ADMIN_SELECTION, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, HOME_SCREEN, (route) => false);
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(context, INTRO, (route) => false);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  MATE_WHITE,
                  DARK_BLUE_COLOR,
                  PURPLE_COLOR,
                ],
              ),
            ),
          ),
          TopAppLogo(height: height / 5),
        ],
      ),
    );
  }
}

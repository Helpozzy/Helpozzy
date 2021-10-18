import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/screens/user/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/utils/constants.dart';

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
          Navigator.pushNamedAndRemoveUntil(
              context, HOME_SCREEN, (route) => false);
          print('ISLOGIN');
        } else {
          print('NOTLOGIN');
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/helpozzy_logo.png',
                  height: height / 6,
                  width: height / 6,
                ),
                Text(
                  HELPOZZY_REMAINING_TEXT,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: DARK_BLACK,
                        fontSize: height / 14,
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

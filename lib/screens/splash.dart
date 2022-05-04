import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpozzy/provider/auth_service.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double height;
  late double width;

  Future runBiomatricAuth() async {
    bool isAuthenticated = await AuthService.authenticateUser();
    if (isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(context, HOME_SCREEN, (route) => false);
      ScaffoldSnakBar().show(context, msg: AUTHENTICATION_SUCCESS_POPUP_MSG);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, INTRO, (route) => false);
      ScaffoldSnakBar().show(context, msg: AUTHENTICATION_FAILED_POPUP_MSG);
    }
  }

  @override
  void initState() {
    // runBiomatricAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(body: body(context));
  }

  Widget body(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthenticateState)
          Navigator.pushNamedAndRemoveUntil(
              context, HOME_SCREEN, (route) => false);
        else
          Navigator.pushNamedAndRemoveUntil(context, INTRO, (route) => false);
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PRIMARY_COLOR,
                  PRIMARY_COLOR,
                  MATE_WHITE,
                ],
              ),
            ),
          ),
          Positioned(
            top: height / 3.5,
            child: TopAppLogo(
              size: height / 5,
              color: WHITE,
            ),
          ),
          Positioned(
            top: height / 2,
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Text(
                HELPOZZY_TAGLINE_TEXT,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: WHITE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

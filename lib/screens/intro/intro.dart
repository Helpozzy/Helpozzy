import 'package:flutter/material.dart';
import 'package:helpozzy/provider/auth_service.dart';
import 'package:helpozzy/screens/intro/intro_widget.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Future runBiomatricAuth() async {
    final bool biomatericAvail = await Authentication.bometricIsSupported();
    if (biomatericAvail) {
      final bool isAuthenticated =
          await Authentication.authenticateWithBiometrics();
      if (isAuthenticated) {
        await Navigator.pushNamedAndRemoveUntil(
            context, HOME_SCREEN, (route) => false);
        ScaffoldSnakBar().show(context, msg: AUTHENTICATION_SUCCESS_POPUP_MSG);
      } else {
        await Navigator.pushNamedAndRemoveUntil(
            context, LOGIN, (route) => false);
        ScaffoldSnakBar().show(context, msg: AUTHENTICATION_FAILED_POPUP_MSG);
      }
    } else {
      await Navigator.pushNamedAndRemoveUntil(context, INTRO, (route) => false);
    }
  }

  @override
  void initState() {
    // runBiomatricAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroWidget(
        signupScreenCallback: (BuildContext context) =>
            Navigator.pushNamed(context, SIGNUP, arguments: {}),
        loginScreenCallback: (BuildContext context) =>
            Navigator.pushNamed(context, LOGIN, arguments: {}),
      ),
    );
  }
}

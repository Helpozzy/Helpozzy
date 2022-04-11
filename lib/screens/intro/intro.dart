import 'package:flutter/material.dart';
import 'package:helpozzy/screens/intro/intro_widget.dart';
import 'package:helpozzy/utils/constants.dart';

class IntroScreen extends StatelessWidget {
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

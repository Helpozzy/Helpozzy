import 'package:flutter/material.dart';
import 'package:helpozzy/screens/intro/slider_widget.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class IntroWidget extends StatelessWidget {
  IntroWidget(
      {required this.signupScreenCallback, required this.loginScreenCallback});
  final Function(BuildContext) loginScreenCallback;
  final Function(BuildContext) signupScreenCallback;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SliderWidget(),
          Padding(
            padding: EdgeInsets.only(top: height * 0.07),
            child: TopAppLogo(
              size: height / 6,
              color: PRIMARY_COLOR,
            ),
          ),
          _createButtonsContainer(context),
        ],
      ),
    );
  }

  Widget _createButtonsContainer(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final _theme = Theme.of(context);
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(5.0),
      margin: EdgeInsets.only(bottom: height * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.10, right: width * 0.10),
            width: double.infinity,
            child: CommonButton(
              text: MSG_SIGN_UP.toUpperCase(),
              onPressed: () => signupScreenCallback(context),
            ),
          ),
          TextButton(
            child: Text(
              MSG_LOGIN,
              style: _theme.textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
                color: WHITE,
              ),
            ),
            onPressed: () => loginScreenCallback(context),
          ),
        ],
      ),
    );
  }
}

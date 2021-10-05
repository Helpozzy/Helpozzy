import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/screens/user/intro/intro_widget.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatelessWidget {
  // This widget is the root of your application.
  final Map<int, Color> color = {
    50: const Color.fromRGBO(250, 202, 88, .1),
    100: const Color.fromRGBO(250, 202, 88, .2),
    200: const Color.fromRGBO(250, 202, 88, .3),
    300: const Color.fromRGBO(250, 202, 88, .4),
    400: const Color.fromRGBO(250, 202, 88, .5),
    500: const Color.fromRGBO(250, 202, 88, .6),
    600: const Color.fromRGBO(250, 202, 88, .7),
    700: const Color.fromRGBO(250, 202, 88, .8),
    800: const Color.fromRGBO(250, 202, 88, .9),
    900: const Color.fromRGBO(250, 202, 88, 1),
  };

  final List<PageItem> arrItems = [
    PageItem(
        imgPath: 'assets/images/slide_one.png',
        text: 'EXPRESS EMPATHY \nTO OTHERS'),
    PageItem(
        imgPath: 'assets/images/slide_two.png',
        text: 'BE MORE \nCOMPASSIONATE'),
    PageItem(
        imgPath: 'assets/images/slide_three.png',
        text: 'GET TOGETHER \nTO SERVE BETTER'),
  ];

  @override
  Widget build(BuildContext context) {
    final MaterialColor colorCustom = MaterialColor(0xFFFACA58, color);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: IntroWidgetNavigationProvider())
      ],
      child: Scaffold(
        body: IntroWidget(
          arrPageItems: arrItems,
          pageIndicatorColor: Colors.grey,
          pageIndicatorSelectedColor: Colors.white,
          buttonsColor: colorCustom,
          buttonsTextColor: Colors.white,
          signupScreenCallback: (BuildContext context) {
            // Goto Sign Up Screen
            Navigator.pushNamed(context, USER_SLECTION, arguments: {});
          },
          loginScreenCallback: (BuildContext context) {
            // Goto Login Screen
            Navigator.pushNamed(context, LOGIN, arguments: {});
          },
        ),
      ),
    );
  }
}

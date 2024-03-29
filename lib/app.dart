import 'dart:math';
import 'package:flutter/material.dart';
import 'package:helpozzy/screens/auth/login/login.dart';
import 'package:helpozzy/screens/auth/signup/1_volunteering_screen.dart';
import 'package:helpozzy/screens/dashboard/dashboard_menu.dart';
import 'package:helpozzy/screens/explore/explore.dart';
import 'package:helpozzy/screens/home/home.dart';
import 'package:helpozzy/screens/intro/intro.dart';
import 'package:helpozzy/utils/constants.dart';
import 'screens/splash.dart';
import 'screens/rewards/rewards.dart';

class HelpozzyApp extends MaterialApp {
  @override
  String get title => HELPOZZY_TEXT;

  @override
  ThemeData get theme => ThemeData(
        primarySwatch: generateMaterialColor(PRIMARY_COLOR),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: PRIMARY_COLOR,
          selectionColor: PRIMARY_COLOR,
          selectionHandleColor: PRIMARY_COLOR,
        ),
        fontFamily: QUICKSAND,
        colorScheme: ColorScheme.light(),
        primaryColor: PRIMARY_COLOR,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            textStyle: TextStyle(
              fontFamily: QUICKSAND,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: PRIMARY_COLOR,
            padding: EdgeInsets.all(10),
            elevation: 5,
            textStyle: TextStyle(
              fontSize: 16,
              fontFamily: QUICKSAND,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: PRIMARY_COLOR,
            elevation: 5,
          ),
        ),
        buttonTheme: ThemeData.light().buttonTheme.copyWith(
              buttonColor: PRIMARY_COLOR,
              padding: EdgeInsets.all(10),
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
        inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
              contentPadding: EdgeInsets.all(10),
              errorMaxLines: 3,
              fillColor: Colors.white,
              filled: true,
              hintStyle: TextStyle(
                color: GRAY,
                fontFamily: QUICKSAND,
                fontSize: 14,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: PRIMARY_COLOR,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: GRAY,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: PRIMARY_COLOR,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: PRIMARY_COLOR,
                  width: 1,
                ),
              ),
              errorStyle: TextStyle(
                fontSize: 13,
                fontFamily: QUICKSAND,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline5: ThemeData.light().textTheme.headline5!.copyWith(
                    fontFamily: QUICKSAND,
                    fontWeight: FontWeight.w500,
                    color: PRIMARY_COLOR,
                  ),
              headline6: ThemeData.light().textTheme.headline5!.copyWith(
                    fontFamily: QUICKSAND,
                    fontWeight: FontWeight.w500,
                    color: PRIMARY_COLOR,
                  ),
              subtitle1: ThemeData.light().textTheme.subtitle1!.copyWith(
                    fontFamily: QUICKSAND,
                    color: BLACK,
                  ),
              subtitle2: ThemeData.light().textTheme.subtitle2!.copyWith(
                    fontFamily: QUICKSAND,
                    color: BLACK,
                  ),
              caption: ThemeData.light().textTheme.caption!.copyWith(
                    fontFamily: QUICKSAND,
                    color: BLACK,
                  ),
              button: ThemeData.light().textTheme.button!.copyWith(
                    fontFamily: QUICKSAND,
                    color: BLACK,
                    fontWeight: FontWeight.w500,
                  ),
              bodyText1: ThemeData.light().textTheme.bodyText1!.copyWith(
                    color: BLACK,
                    fontFamily: QUICKSAND,
                  ),
              bodyText2: ThemeData.light().textTheme.bodyText2!.copyWith(
                    color: BLACK,
                    fontWeight: FontWeight.w500,
                    fontFamily: QUICKSAND,
                  ),
            ),
      );

  @override
  Map<String, WidgetBuilder> get routes => {
        '/': (context) => SplashScreen(),
        INTRO: (context) => IntroScreen(),
        DASHBOARD: (context) => DashboardScreen(),
        LOGIN: (context) => Login(),
        SIGNUP: (context) => SignUpScreen(),
        HOME_SCREEN: (context) => HomeScreen(),
        EXPLORE_SCREEN: (context) => ExploreScreen(),
        REWARDS_SCREEN: (context) => RewardsScreen(initialIndex: 0),
      };

  @override
  bool get debugShowCheckedModeBanner => false;
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

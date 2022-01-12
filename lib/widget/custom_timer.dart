import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class CustomCoutDownTimer extends StatefulWidget {
  CustomCoutDownTimer({required this.hrs});
  final int hrs;
  @override
  _CustomCoutDownTimerState createState() =>
      _CustomCoutDownTimerState(hrs: hrs);
}

class _CustomCoutDownTimerState extends State<CustomCoutDownTimer> {
  _CustomCoutDownTimerState({required this.hrs});
  late int hrs;

  DateTime eventDate = DateTime(2022, 01, 14, 12, 00);

  late Duration duration = Duration();

  /// Get the remaining hours always with two digits.
  String get hours => fill(duration.inHours.remainder(24));

  /// Get the remaining minutes always with two digits.
  String get minutes => fill(duration.inMinutes.remainder(60));

  /// Get the remaining seconds always with two digits.
  String get seconds => fill(duration.inSeconds.remainder(60));

  String fill(int n, {int count = 2}) => n.toString().padLeft(count, '0');

  @override
  void initState() {
    runCountDown();
    super.initState();
  }

  Future runCountDown() async {
    Timer.periodic(const Duration(seconds: 1), (callback) {
      duration = eventDate.difference(DateTime.now());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            LabelText(string: 'Hr', isKey: true),
            LabelText(string: 'Min', isKey: true),
            LabelText(string: 'Sec', isKey: true),
          ],
        ),
        Row(
          children: [
            LabelText(string: hours),
            seprator,
            LabelText(string: minutes),
            seprator,
            LabelText(string: seconds),
          ],
        ),
      ],
    );
  }

  Widget get seprator => Text(
        ':',
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(fontSize: 10, fontWeight: FontWeight.bold),
      );
}

class LabelText extends StatelessWidget {
  LabelText({required this.string, this.isKey = false});

  final String string;
  final bool isKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isKey
          ? EdgeInsets.symmetric(horizontal: 8)
          : EdgeInsets.only(top: 3, right: 5, left: 5),
      padding:
          isKey ? null : EdgeInsets.symmetric(vertical: 2.5, horizontal: 3.5),
      decoration: isKey
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: GRAY,
            ),
      child: Text(
        '$string',
        style: isKey
            ? Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 8)
            : Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 8,
                  color: DARK_GRAY_FONT_COLOR,
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }
}

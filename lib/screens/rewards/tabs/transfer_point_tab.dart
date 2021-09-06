import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class TransferPointTabScreen extends StatefulWidget {
  const TransferPointTabScreen({Key? key}) : super(key: key);

  @override
  _TransferPointTabScreenState createState() => _TransferPointTabScreenState();
}

class _TransferPointTabScreenState extends State<TransferPointTabScreen> {
  late ThemeData _theme;
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: LIGHT_ACCENT_GRAY,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AVAILABLE_POINT,
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '35',
                style: _theme.textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

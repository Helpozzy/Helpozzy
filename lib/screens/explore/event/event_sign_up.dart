import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class EventSignUpScreen extends StatefulWidget {
  const EventSignUpScreen({Key? key}) : super(key: key);

  @override
  _EventSignUpScreenState createState() => _EventSignUpScreenState();
}

class _EventSignUpScreenState extends State<EventSignUpScreen> {
  late ThemeData _theme;
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: SIGN_UP),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        contactProjectLeadSection(),
      ],
    );
  }

  Widget contactProjectLeadSection() {
    return Container(
      color: SCREEN_BACKGROUND,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 27),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            CONTACT_PRO_LEAD,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.chat_outlined,
            color: BLUE,
            size: 20,
          ),
        ],
      ),
    );
  }
}
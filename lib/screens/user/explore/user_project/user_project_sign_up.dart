import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class ProjectUserSignUpScreen extends StatefulWidget {
  @override
  _ProjectUserSignUpScreenState createState() =>
      _ProjectUserSignUpScreenState();
}

class _ProjectUserSignUpScreenState extends State<ProjectUserSignUpScreen> {
  late ThemeData _theme;
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CommonAppBar(context).show(title: SIGN_UP, elevation: 1),
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
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27),
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

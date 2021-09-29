import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class UpcomingTab extends StatefulWidget {
  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CommonButtonWithIcon(
            text: ADD_NEW_PROJECT_BUTTON,
            icon: CupertinoIcons.add_circled,
            onPressed: () {},
          ),
        )
      ],
    );
  }
}

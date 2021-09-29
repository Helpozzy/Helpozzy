import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/screens/user/auth/user/bloc/auth_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:provider/provider.dart';

class CommonSampleScreen extends StatefulWidget {
  final String title;
  const CommonSampleScreen(this.title);

  @override
  _CommonSampleScreenState createState() => _CommonSampleScreenState();
}

class _CommonSampleScreenState extends State<CommonSampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(50),
            width: double.infinity,
            child: CommonButton(
                text: 'Logout',
                onPressed: () async {
                  Provider.of<AuthBloc>(context, listen: false)
                      .add(AppLogout());
                  Navigator.pushNamedAndRemoveUntil(
                      context, INTRO, (route) => false);
                }),
          ),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: DARK_MARUN,
            ),
          ),
        ],
      ),
    );
  }
}

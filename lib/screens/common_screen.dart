import 'package:flutter/material.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
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
      appBar: CommonAppBar(context).show(
        title: 'Common Screen',
        backButton: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: DARK_MARUN,
            ),
          ),
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
        ],
      ),
    );
  }
}

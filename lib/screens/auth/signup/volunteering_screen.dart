import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/volunteer_bloc.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:helpozzy/screens/auth/signup/personal_info_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;
  @override
  _SignUpScreenState createState() =>
      _SignUpScreenState(signupAndUserModel: signupAndUserModel);
}

class _SignUpScreenState extends State<SignUpScreen> {
  _SignUpScreenState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;
  late double width;
  late double height;
  late ThemeData _theme;
  final AirportDetailBloc _airportDetailBloc = AirportDetailBloc();

  @override
  void initState() {
    _airportDetailBloc.getVolunteerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: SCREEN_BACKGROUND,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: topIconSection(context, SELECT_CATEGORY),
          ),
          volunteerList(),
        ],
      ),
    );
  }

  Widget topIconSection(context, title) {
    return Column(
      children: [
        CommonWidget(context).showBackButton(),
        TopAppLogo(height: height / 6),
        Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.05),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: _theme.textTheme.headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget volunteerList() {
    return StreamBuilder<VolunteerTypes>(
      stream: _airportDetailBloc.volunteersListStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(color: PRIMARY_COLOR);
        }
        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.volunteers.length,
            itemBuilder: (context, index) {
              final VolunteerModel _item = snapshot.data!.volunteers[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: width * 0.15,
                ),
                child: CommonButton(
                  fontSize: 17,
                  color: LIGHT_BLACK,
                  text: _item.type,
                  onPressed: () {
                    signupAndUserModel.volunteerType = index;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoScreen(
                            signupAndUserModel: signupAndUserModel),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

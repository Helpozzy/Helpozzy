import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/volunteer_bloc.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:helpozzy/screens/auth/signup/2_personal_info_screen.dart';
import 'package:helpozzy/screens/auth/signup/organization_sign_up.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late double width;
  late double height;
  late ThemeData _theme;
  final VolunteerBloc _volunteerBloc = VolunteerBloc();

  @override
  void initState() {
    _volunteerBloc.getVolunteerList();
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
          topIconSection(SELECT_USER_TYPE),
          volunteerList(),
        ],
      ),
    );
  }

  Widget topIconSection(title) {
    return Column(
      children: [
        CommonWidget(context).showBackButton(),
        SizedBox(height: height / 10),
        TopAppLogo(size: height / 6),
        SizedBox(height: 35),
        Text(
          title,
          textAlign: TextAlign.center,
          style:
              _theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget volunteerList() {
    return StreamBuilder<VolunteerTypes>(
      stream: _volunteerBloc.volunteersListStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.only(top: width * 0.2),
            child: CircularProgressIndicator(color: PRIMARY_COLOR),
          );
        }
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
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
                    SignUpAndUserModel signupAndUserModel =
                        SignUpAndUserModel(volunteerType: index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => index == 2
                            ? OrganizationSignUp()
                            : PersonalInfoScreen(
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

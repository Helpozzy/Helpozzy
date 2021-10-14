import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/volunteer_bloc.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/models/volunteer_type_model.dart';
import 'package:helpozzy/screens/user/auth/signup/living_info_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({required this.signUpModel});
  final SignUpModel signUpModel;
  @override
  _SignUpScreenState createState() =>
      _SignUpScreenState(signUpModel: signUpModel);
}

class _SignUpScreenState extends State<SignUpScreen> {
  _SignUpScreenState({required this.signUpModel});
  final SignUpModel signUpModel;
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
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(top: height * 0.05, right: width * 0.05),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: CLOSE_ICON,
              ),
            ),
          ),
        ),
        TopAppLogo(height: height / 6),
        Container(
          margin: EdgeInsets.only(top: height * 0.05, bottom: height * 0.05),
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
    return Expanded(
      child: StreamBuilder<VolunteerTypes>(
        stream: _airportDetailBloc.volunteersListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(color: PRIMARY_COLOR));
          }
          return ListView.builder(
            itemCount: snapshot.data!.volunteers.length,
            itemBuilder: (context, index) {
              final _item = snapshot.data!.volunteers[index];
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
                    signUpModel.volunteerType = index;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LivingInfoScreen(signUpModel: signUpModel),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

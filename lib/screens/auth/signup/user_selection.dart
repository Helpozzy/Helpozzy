import 'package:flutter/material.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/auth/signup/volunteering_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class UserTypeSelection extends StatefulWidget {
  @override
  _UserTypeSelectionState createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SCREEN_BACKGROUND,
      body: SingleChildScrollView(
        child: UserSelection(),
      ),
    );
  }
}

class UserSelection extends StatefulWidget {
  @override
  State<UserSelection> createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  final _formKey = GlobalKey<FormState>();
  late String modeDropdownValue = '';
  late TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.05, bottom: height * 0.10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin:
                    EdgeInsets.only(right: width * 0.07, bottom: width * 0.14),
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
            TopInfoLabel(label: SELECT_USER_TYPE),
            selectUserTypeDropdown(),
            Container(
              margin: buildEdgeInsetsCustom(width, 0.20, 20.0, 0.20, 15.0),
              width: double.infinity,
              child: CommonButton(
                text: CONTINUE_BUTTON.toUpperCase(),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_typeController.text == LOGIN_VOLUNTEER) {
                      final SignUpAndUserModel signUpModel =
                          SignUpAndUserModel(userType: _typeController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignUpScreen(signUpModel: signUpModel),
                        ),
                      );
                    } else if (_typeController.text == LOGIN_ADMIN) {
                      final SignUpAndUserModel signUpModel =
                          SignUpAndUserModel(userType: _typeController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignUpScreen(signUpModel: signUpModel),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectUserTypeDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: DropdownButtonFormField<String>(
          decoration: inputRoundedDecoration(
              getHint: SELECT_TYPE_HINT, isDropDown: true),
          icon: Icon(Icons.expand_more_outlined),
          validator: (val) {
            if (_typeController.text.isEmpty) {
              return 'Select user want to continue';
            }
            return null;
          },
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              _typeController.text = newValue!;
            });
          },
          items: loginModes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList()),
    );
  }
}

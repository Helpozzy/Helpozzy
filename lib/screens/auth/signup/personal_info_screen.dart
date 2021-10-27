import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/screens/auth/signup/birthdate_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class PersonalInfoScreen extends StatefulWidget {
  PersonalInfoScreen({required this.signUpModel});
  final SignUpModel signUpModel;

  @override
  _PersonalInfoScreenState createState() =>
      _PersonalInfoScreenState(signUpModel: signUpModel);
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  _PersonalInfoScreenState({required this.signUpModel});
  final SignUpModel signUpModel;
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: SCREEN_BACKGROUND,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CommonWidget(context).showBackButton(),
                    TopInfoLabel(label: ENTER_YOUR_NAME),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.19, vertical: 4.0),
                      child: TextfieldLabelSmall(label: FIRST_NAME),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: CommonRoundedTextfield(
                        controller: _firstNameController,
                        hintText: ENTER_FIRST_NAME_HINT,
                        validator: (fname) {
                          if (fname!.isEmpty) {
                            return 'Please enter first name';
                          } else if (fname.isNotEmpty && fname.length <= 3) {
                            return 'Please enter more than 3 charcters';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.19, vertical: 4.0),
                      child: TextfieldLabelSmall(label: LAST_NAME),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: CommonRoundedTextfield(
                        controller: _lastNameController,
                        hintText: ENTER_LAST_NAME_HINT,
                        validator: (lname) {
                          if (lname!.isEmpty) {
                            return 'Please enter last name';
                          } else if (lname.isNotEmpty && lname.length <= 3) {
                            return 'Please enter more than 3 charcters';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    TopInfoLabel(label: ENTER_YOUR_EMAIL),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: CommonRoundedTextfield(
                        controller: _emailController,
                        hintText: ENTER_EMAIL_HINT,
                        validator: (email) {
                          if (email!.isEmpty) {
                            return 'Please enter email';
                          } else if (email.isNotEmpty &&
                              !EmailValidator.validate(email)) {
                            return 'Please enter valid email';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: width * 0.15,
              ),
              width: double.infinity,
              child: CommonButton(
                text: CONTINUE_BUTTON,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  signUpModel.name = _firstNameController.text +
                      ' ' +
                      _lastNameController.text;
                  signUpModel.email = _emailController.text;
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BirthDateScreen(signUpModel: signUpModel),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

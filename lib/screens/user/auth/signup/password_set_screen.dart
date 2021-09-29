import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/signup_bloc.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/screens/user/home/home.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class PasswordSetScreen extends StatelessWidget {
  PasswordSetScreen({required this.signUpModel});
  final SignUpModel signUpModel;

  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final SignUpBloc _signUpBloc = SignUpBloc();

  bool checkPassStrength(String pass) {
    final checkStrongPass =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})')
            .hasMatch(pass);
    return checkStrongPass;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                    TopInfoLabel(label: CHOOSE_YOUR_PASSWORD),
                    CommonTextfield(
                      obscureText: true,
                      controller: _passController,
                      hintText: ENTER_PASSWORD_HINT,
                      validator: (password) {
                        if (password!.isEmpty) {
                          return 'Please enter password';
                        } else if (password.isNotEmpty && password.length < 8) {
                          return 'Password must be at least 8 characters';
                        } else if (password.isNotEmpty &&
                            !checkPassStrength(password)) {
                          return "Password must contains 'A-z, Special char, 1-9'";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    CommonTextfield(
                      obscureText: true,
                      controller: _confirmPassController,
                      hintText: ENTER_CONFIRM_PASSWORD_HINT,
                      validator: (confirmPass) {
                        if (confirmPass!.isEmpty) {
                          return 'Please enter confirm password';
                        } else if (confirmPass != _passController.text) {
                          return 'Does not match';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              margin: bottomContinueBtnEdgeInsets(width, height),
              width: double.infinity,
              child: CommonButton(
                text: CONTINUE_BUTTON,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    CircularLoader().show(context);
                    _signUpBloc
                        .registerUser(signUpModel, _confirmPassController.text)
                        .then((response) {
                      CircularLoader().hide(context);
                      if (response)
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false);
                      else
                        showSnakeBar(context, msg: 'Sign-Up Failed!');
                    });
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

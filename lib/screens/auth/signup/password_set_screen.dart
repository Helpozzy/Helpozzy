import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/signup_bloc.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SetPasswordScreen extends StatefulWidget {
  SetPasswordScreen({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  static final _formKey = GlobalKey<FormState>();

  @override
  State<SetPasswordScreen> createState() =>
      _SetPasswordScreenState(signupAndUserModel: signupAndUserModel);
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  _SetPasswordScreenState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final SignUpBloc _signUpBloc = SignUpBloc();
  late bool showPass = false;
  late bool showConfirmPass = false;
  late ThemeData _theme;
  final popupKey = GlobalKey();

  bool checkPassStrength(String pass) {
    final checkStrongPass =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})')
            .hasMatch(pass);
    return checkStrongPass;
  }

  Future onRegister() async {
    FocusScope.of(context).unfocus();
    if (SetPasswordScreen._formKey.currentState!.validate()) {
      CircularLoader().show(context);
      signupAndUserModel.joiningDate =
          DateTime.now().millisecondsSinceEpoch.toString();
      _signUpBloc
          .registerUser(signupAndUserModel, _confirmPassController.text)
          .then((response) {
        CircularLoader().hide(context);
        if (response)
          Navigator.pushNamedAndRemoveUntil(
              context, HOME_SCREEN, (route) => false);
        else
          ScaffoldSnakBar().show(context, msg: SIGN_UP_FAILED_POPUP_MSG);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: SCREEN_BACKGROUND,
      body: Form(
        key: SetPasswordScreen._formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonWidget(context).showBackButton(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.05, right: width * 0.03),
                    child: IconButton(
                        onPressed: () => onRegister(),
                        icon: Icon(CupertinoIcons.checkmark_alt)),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TopInfoLabel(label: CHOOSE_YOUR_PASSWORD),
                    Tooltip(
                      key: popupKey,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: width * 0.04),
                      message:
                          '- At least 8 characters—the more characters, the better.'
                          '\n- A mixture of both uppercase and lowercase letters.'
                          '\n- A mixture of letters and numbers.'
                          '\n- Inclusion of at least one special character'
                          '\n e.g., ! @ # ? ]',
                      textStyle: _theme.textTheme.bodyText2,
                      decoration: BoxDecoration(
                          color: WHITE,
                          borderRadius: BorderRadius.circular(12)),
                      child: IconButton(
                        onPressed: () {
                          final dynamic tooltip = popupKey.currentState;
                          tooltip.ensureTooltipVisible();
                        },
                        icon: Icon(CupertinoIcons.question_circle),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: StreamBuilder<bool>(
                  initialData: showPass,
                  stream: _signUpBloc.showPassStream,
                  builder: (context, snapshot) {
                    return CommonRoundedTextfield(
                      obscureText: !snapshot.data!,
                      controller: _passController,
                      hintText: ENTER_PASSWORD_HINT,
                      suffixIcon: IconButton(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            snapshot.data!
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: DARK_GRAY,
                            size: 18,
                          ),
                        ),
                        onPressed: () {
                          showPass = !showPass;
                          _signUpBloc.changeShowPass(showPass);
                        },
                      ),
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
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: StreamBuilder<bool>(
                  initialData: showConfirmPass,
                  stream: _signUpBloc.showConfirmPassStream,
                  builder: (context, snapshot) {
                    return CommonRoundedTextfield(
                      obscureText: !snapshot.data!,
                      controller: _confirmPassController,
                      hintText: ENTER_CONFIRM_PASSWORD_HINT,
                      suffixIcon: IconButton(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            snapshot.data!
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: DARK_GRAY,
                            size: 18,
                          ),
                        ),
                        onPressed: () {
                          showConfirmPass = !showConfirmPass;
                          _signUpBloc.changeShowPass(showConfirmPass);
                        },
                      ),
                      validator: (confirmPass) {
                        if (confirmPass!.isEmpty) {
                          return 'Please enter confirm password';
                        } else if (confirmPass != _passController.text) {
                          return 'Does not match';
                        } else {
                          return null;
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

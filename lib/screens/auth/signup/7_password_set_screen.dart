import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/signup_bloc.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/provider/auth_service.dart';
import 'package:helpozzy/screens/auth/signup/privacy_policy_or_terms_condition.dart';
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
  late double height;
  late double width;
  late bool enableBiometric = false;
  late bool biometricAvail = false;

  bool checkPassStrength(String pass) {
    final checkStrongPass =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})')
            .hasMatch(pass);
    return checkStrongPass;
  }

  Future getBiometricSupported() async {
    biometricAvail = await Authentication().bometricIsSupported();
    setState(() {});
  }

  Future onRegister(bool termsAndConditionChecked) async {
    FocusScope.of(context).unfocus();
    if (SetPasswordScreen._formKey.currentState!.validate()) {
      CircularLoader().show(context);
      signupAndUserModel.profileUrl = APP_ICON_URL;
      signupAndUserModel.totalSpentHrs = 0;
      signupAndUserModel.rating = 0.0;
      signupAndUserModel.pointGifted = 0;
      signupAndUserModel.joiningDate =
          DateTime.now().millisecondsSinceEpoch.toString();
      signupAndUserModel.lastSeen =
          DateTime.now().millisecondsSinceEpoch.toString();
      signupAndUserModel.presence = false;
      // signupAndUserModel.biometricEnable = enableBiometric;
      if (termsAndConditionChecked) {
        _signUpBloc
            .registerUser(signupAndUserModel, _confirmPassController.text)
            .then((response) {
          CircularLoader().hide(context);
          if (response.status!)
            Navigator.pushNamedAndRemoveUntil(
                context, HOME_SCREEN, (route) => false);
          else
            ScaffoldSnakBar().show(context, msg: response.error!);
        });
      } else {
        CircularLoader().hide(context);
        ScaffoldSnakBar().show(
          context,
          msg: 'Please accept Terms & Conditions and Privacy Policy.',
        );
      }
    }
  }

  @override
  void initState() {
    getBiometricSupported();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
                    child: StreamBuilder<bool>(
                      initialData: false,
                      stream: _signUpBloc.termsConditionStream,
                      builder: (context, snapshot) {
                        return IconButton(
                          onPressed: () => onRegister(snapshot.data!),
                          icon: Icon(CupertinoIcons.checkmark_alt),
                        );
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TopInfoLabel(label: CHOOSE_YOUR_PASSWORD),
                    toolTipWidget(),
                  ],
                ),
              ),
              passwordField(),
              SizedBox(height: 15),
              confirmPassField(),
              termsAndConditionPrivacyPolicy(),
              // biometricAvail
              //     ? TopInfoLabel(label: PRIVACY_AND_SECURITY)
              //     : SizedBox(),
              // biometricAvail ? biomerticOption() : SizedBox(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: width * 0.06,
                  horizontal: width * 0.1,
                ),
                child: StreamBuilder<bool>(
                  initialData: false,
                  stream: _signUpBloc.termsConditionStream,
                  builder: (context, snapshot) {
                    return CommonButton(
                      text: SUBMIT_BUTTON,
                      onPressed: () => onRegister(snapshot.data!),
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

  Widget toolTipWidget() {
    return Tooltip(
      key: popupKey,
      margin: EdgeInsets.symmetric(horizontal: width * 0.06),
      padding: EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: width * 0.03,
      ),
      message: PASSWORD_TOOLTIP,
      textStyle: _theme.textTheme.bodyText2!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: PRIMARY_COLOR,
      ),
      decoration: BoxDecoration(
        color: WHITE,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () {
          final dynamic tooltip = popupKey.currentState;
          tooltip.ensureTooltipVisible();
        },
        icon: Icon(CupertinoIcons.question_circle),
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: StreamBuilder<bool>(
        initialData: showPass,
        stream: _signUpBloc.showPassStream,
        builder: (context, snapshot) {
          return CommonRoundedTextfield(
            obscureText: !snapshot.data!,
            controller: _passController,
            hintText: ENTER_PASSWORD_HINT,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              icon: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  snapshot.data!
                      ? CupertinoIcons.eye
                      : CupertinoIcons.eye_slash,
                  color: DARK_GRAY,
                  size: 16,
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
              } else if (password.isNotEmpty && !checkPassStrength(password)) {
                return "Password must contains 'A-z, Special char, 1-9'";
              }
              return null;
            },
          );
        },
      ),
    );
  }

  Widget confirmPassField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: StreamBuilder<bool>(
        initialData: showConfirmPass,
        stream: _signUpBloc.showConfirmPassStream,
        builder: (context, snapshot) {
          return CommonRoundedTextfield(
            obscureText: !snapshot.data!,
            controller: _confirmPassController,
            hintText: ENTER_CONFIRM_PASSWORD_HINT,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              icon: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  snapshot.data!
                      ? CupertinoIcons.eye
                      : CupertinoIcons.eye_slash,
                  color: DARK_GRAY,
                  size: 16,
                ),
              ),
              onPressed: () {
                showConfirmPass = !showConfirmPass;
                _signUpBloc.changeShowConfirmPass(showConfirmPass);
              },
            ),
            validator: (confirmPass) {
              if (confirmPass!.isEmpty) {
                return 'Please enter confirm password';
              } else if (confirmPass != _passController.text) {
                return 'Does not match';
              }
              return null;
            },
          );
        },
      ),
    );
  }

  Widget termsAndConditionPrivacyPolicy() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.13, vertical: width * 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: Transform.scale(
              scale: 0.7,
              child: StreamBuilder<bool>(
                initialData: false,
                stream: _signUpBloc.termsConditionStream,
                builder: (context, snapshot) {
                  return Checkbox(
                    value: snapshot.data,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) =>
                        _signUpBloc.changeTermsConditionPrivacyPolicy(val!),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: TERMS_AND_CONDITION_1,
                    style: _theme.textTheme.bodySmall!.copyWith(
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  TextSpan(
                    text: TERMS_AND_CONDITION,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async => await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => PrivacyPolicy(),
                            ),
                          ),
                    style: _theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  TextSpan(
                    text: TERMS_AND_CONDITION_2,
                    style: _theme.textTheme.bodySmall!.copyWith(
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  TextSpan(
                    text: PRIVACY_POLICY,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async => await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => PrivacyPolicy(),
                            ),
                          ),
                    style: _theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget biomerticOption() {
  //   return Padding(
  //     padding: EdgeInsets.only(left: width * 0.1, right: width * 0.08),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           FINGERPRINT_AND_FACE_ID,
  //           style: _theme.textTheme.bodyText2!.copyWith(fontSize: 16),
  //         ),
  //         Transform.scale(
  //           scale: 0.7,
  //           child: CupertinoSwitch(
  //             trackColor: DARK_GRAY,
  //             activeColor: DARK_PINK_COLOR,
  //             value: enableBiometric,
  //             onChanged: (val) =>
  //                 setState(() => enableBiometric = !enableBiometric),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

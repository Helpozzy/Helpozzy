import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/signup_bloc.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/auth/signup/6_target_and_area_of_interest.dart';
import 'package:helpozzy/screens/auth/signup/5_school_and_grade_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';

class ContactInfoScreen extends StatefulWidget {
  ContactInfoScreen({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  @override
  _ContactInfoScreenState createState() =>
      _ContactInfoScreenState(signupAndUserModel: signupAndUserModel);
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  _ContactInfoScreenState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final SignUpBloc _signUpBloc = SignUpBloc();
  late double width;
  late double height;

  Future streamOncontinue(AsyncSnapshot<bool> snapshot) async {
    FocusScope.of(context).unfocus();
    signupAndUserModel.parentEmail = _parentEmailController.text;
    signupAndUserModel.relationshipWithParent = _relationController.text;

    if (_formKey.currentState!.validate()) {
      if (snapshot.data!) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => signupAndUserModel.volunteerType == 1
                ? SchoolAndGradeScreen(signupAndUserModel: signupAndUserModel)
                : TargetAndAreaOfInterest(
                    signupAndUserModel: signupAndUserModel),
          ),
        );
      } else {
        PlatformAlertDialog().show(context,
            title: ALERT,
            content: 'Parent/Guardian email is not verified, '
                'Please verify your email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: SCREEN_BACKGROUND,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<bool>(
                  initialData: false,
                  stream: _signUpBloc.parentEmailVerifiedStream,
                  builder: (context, snapshot) {
                    return CommonWidget(context).showBackForwardButton(
                      onPressedForward: () => streamOncontinue(snapshot),
                    );
                  }),
              TopInfoLabel(label: ENTER_PARENT_EMAIL),
              emailSection(),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.16,
                  vertical: 4.0,
                ),
                child: TextfieldLabelSmall(label: RELATIONSHIP_STATUS),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.10),
                child: selectRelationshipDropdown(),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: width * 0.06, horizontal: width * 0.1),
                child: StreamBuilder<bool>(
                  initialData: false,
                  stream: _signUpBloc.parentEmailVerifiedStream,
                  builder: (context, snapshot) {
                    return CommonButton(
                      text: CONTINUE_BUTTON,
                      onPressed: () => streamOncontinue(snapshot),
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

  Widget emailSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<bool>(
              initialData: false,
              stream: _signUpBloc.parentEmailVerifiedStream,
              builder: (context, snapshotEmailVerified) {
                return CommonRoundedTextfield(
                  controller: _parentEmailController,
                  hintText: ENTER_EMAIL_HINT,
                  suffixIcon: Icon(
                      snapshotEmailVerified.data!
                          ? CupertinoIcons.checkmark_seal_fill
                          : CupertinoIcons.checkmark_seal,
                      size: 18,
                      color: snapshotEmailVerified.data!
                          ? ACCENT_GREEN
                          : DARK_GRAY),
                  validator: (parentEmail) {
                    if (parentEmail!.isEmpty) {
                      return 'Please enter parents/guardian email';
                    } else if (parentEmail.isNotEmpty &&
                        !EmailValidator.validate(parentEmail)) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                );
              }),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
            child: SmallCommonButton(
              fontSize: 10,
              text: SEND_VERIFICATION_CODE_BUTTON,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (_parentEmailController.text.trim().isNotEmpty)
                  _signUpBloc.sentOtpOfParentEmail(_parentEmailController.text);
                else
                  PlatformAlertDialog().show(context,
                      title: ALERT, content: 'Parent/Guardian email is empty');
              },
            ),
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: _signUpBloc.parentOtpSentStream,
            builder: (context, snapshotSentOtp) {
              return snapshotSentOtp.data!
                  ? CommonRoundedTextfield(
                      hintText: ENTER_OTP_HINT,
                      controller: _otpController,
                      maxLength: 6,
                      onChanged: (val) {
                        if (val.isNotEmpty && val.length == 6)
                          _signUpBloc.verifyParentEmail(
                              _parentEmailController.text, _otpController.text);
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter OTP';
                        } else if (val.isNotEmpty && val.length != 6) {
                          return 'Please enter 6 digit OTP';
                        } else {
                          return null;
                        }
                      },
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget selectRelationshipDropdown() {
    return DropdownButtonFormField<String>(
      icon: Icon(Icons.expand_more_rounded),
      isExpanded: true,
      decoration: inputRoundedDecoration(
          getHint: SELECT_RELATION_HINT, isDropDown: true),
      onChanged: (String? newValue) {
        setState(() {
          _relationController.text = newValue!;
        });
      },
      validator: (val) {
        if (val == null && _relationController.text.isEmpty) {
          return 'Select relationship status';
        }
        return null;
      },
      items: relationShips.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }
}

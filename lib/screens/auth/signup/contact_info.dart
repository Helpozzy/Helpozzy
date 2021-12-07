import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/signup_bloc.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/auth/signup/target_and_area_of_interest.dart';
import 'package:helpozzy/screens/auth/signup/school_and_grade_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

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

  final TextEditingController _personalPhoneController =
      TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final SignUpBloc _signUpBloc = SignUpBloc();
  CountryCode? countryCode;
  late ThemeData _theme;
  late double width;
  late double height;
  late bool showParentFields = true;

  @override
  void initState() {
    countryCode = CountryCode(code: '+1', name: 'US');
    getAgeFromDOB();
    super.initState();
  }

  Future getAgeFromDOB() async {
    final dateOfBirth = DateTime.fromMillisecondsSinceEpoch(
        int.parse(signupAndUserModel.dateOfBirth!));
    final currentDate = DateTime.now();
    final Duration duration = currentDate.difference(dateOfBirth);
    final int diff = (duration.inDays / 365).floor();
    if (diff > 18) {
      showParentFields = false;
    } else {
      showParentFields = true;
    }
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
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CommonWidget(context).showBackButton(),
                    TopInfoLabel(label: ENTER_PERSONAL_PHONE_NUMBER),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: CommonRoundedTextfield(
                        controller: _personalPhoneController,
                        prefixIcon: countryCodePicker(),
                        hintText: ENTER_PHONE_NUMBER_HINT,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        validator: (phone) {
                          if (phone!.isEmpty) {
                            return 'Please enter phone number';
                          } else if (phone.isNotEmpty && phone.length != 10) {
                            return 'Please enter 10 digit number';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    showParentFields
                        ? TopInfoLabel(label: ENTER_PARENT_EMAIL)
                        : SizedBox(),
                    showParentFields ? emailSection() : SizedBox(),
                    showParentFields ? SizedBox(height: 10) : SizedBox(),
                    showParentFields
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.16, vertical: 4.0),
                            child:
                                TextfieldLabelSmall(label: RELATIONSHIP_STATUS),
                          )
                        : SizedBox(),
                    showParentFields
                        ? Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.10),
                            child: selectRelationshipDropdown(),
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: width * 0.15,
                  right: width * 0.15,
                  bottom: height * 0.03),
              width: double.infinity,
              child: StreamBuilder<bool>(
                initialData: false,
                stream: _signUpBloc.parentEmailVerifiedStream,
                builder: (context, snapshot) {
                  return CommonButton(
                    text: CONTINUE_BUTTON,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      signupAndUserModel.countryCode = countryCode!.code!;
                      signupAndUserModel.personalPhnNo =
                          _personalPhoneController.text;

                      signupAndUserModel.parentEmail =
                          showParentFields ? _parentEmailController.text : '';
                      signupAndUserModel.relationshipWithParent =
                          showParentFields ? _relationController.text : '';

                      if (_formKey.currentState!.validate()) {
                        if (snapshot.data!) {
                          if (signupAndUserModel.volunteerType == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchoolAndGradeScreen(
                                      signupAndUserModel: signupAndUserModel)),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TargetAndAreaOfInterest(
                                      signupAndUserModel: signupAndUserModel)),
                            );
                          }
                        } else {
                          showAlertDialog(context,
                              title: ALERT,
                              content:
                                  'Parent/Guardian email is not verified, Please verify your email.');
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget countryCodePicker() {
    return CountryCodePicker(
      onChanged: (CountryCode code) => countryCode = code,
      boxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      initialSelection: 'US',
      backgroundColor: WHITE,
      padding: EdgeInsets.only(left: width * 0.03),
      showCountryOnly: false,
      dialogSize: Size(width, height - 30),
      showFlagMain: true,
      dialogTextStyle: Theme.of(context).textTheme.bodyText2,
      flagWidth: 25.0,
      showOnlyCountryWhenClosed: false,
      showFlag: false,
      showFlagDialog: true,
      favorite: ['+1', 'US'],
      textStyle: Theme.of(context).textTheme.bodyText2,
      closeIcon: Icon(Icons.close_rounded),
      searchDecoration: inputRoundedDecoration(getHint: SEARCH_COUNTRY_HINT),
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
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              if (_parentEmailController.text.trim().isNotEmpty)
                _signUpBloc.sentOtpOfParentEmail(_parentEmailController.text);
              else
                showAlertDialog(context,
                    title: 'Alert', content: 'Parent/Guardian email is empty');
            },
            child: Container(
              alignment: Alignment.centerRight,
              padding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: width * 0.04),
              child: Text(
                SENT_OTP_BUTTON,
                style:
                    _theme.textTheme.bodyText2!.copyWith(color: PRIMARY_COLOR),
              ),
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
      icon: Icon(Icons.expand_more_outlined),
      isExpanded: true,
      decoration: inputRoundedDecoration(
          getHint: SELECT_RELATION_HINT, isDropDown: true),
      onChanged: (String? newValue) {
        setState(() {
          _relationController.text = newValue!;
        });
      },
      validator: (val) {
        if (_relationController.text.isEmpty) {
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

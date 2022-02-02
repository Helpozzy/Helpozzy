import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/signup_bloc.dart';
import 'package:helpozzy/helper/date_format_helper.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/auth/signup/living_info_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';

class PersonalInfoScreen extends StatefulWidget {
  PersonalInfoScreen({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  @override
  _PersonalInfoScreenState createState() =>
      _PersonalInfoScreenState(signupAndUserModel: signupAndUserModel);
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  _PersonalInfoScreenState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _personalPhoneController =
      TextEditingController();
  final SignUpBloc _signUpBloc = SignUpBloc();
  late DateTime _selectedBirthDate = DateTime.now();

  late double width;
  late double height;
  CountryCode? countryCode;

  @override
  void initState() {
    countryCode = CountryCode(code: '+1', name: 'US');
    super.initState();
  }

  Future onContinue(AsyncSnapshot<bool> snapshot) async {
    FocusScope.of(context).unfocus();
    signupAndUserModel.name =
        _firstNameController.text + ' ' + _lastNameController.text;
    signupAndUserModel.email = _emailController.text;
    signupAndUserModel.dateOfBirth =
        _selectedBirthDate.millisecondsSinceEpoch.toString();
    signupAndUserModel.countryCode = countryCode!.code!;
    signupAndUserModel.personalPhnNo = _personalPhoneController.text;
    signupAndUserModel.gender = _genderController.text;
    if (_formKey.currentState!.validate()) {
      if (snapshot.data!) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LivingInfoScreen(signupAndUserModel: signupAndUserModel),
          ),
        );
      } else {
        PlatformAlertDialog().show(context,
            title: ALERT,
            content: 'Email is not verified, Please verify your email.');
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
      body: GestureDetector(
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<bool>(
                  initialData: false,
                  stream: _signUpBloc.emailVerifiedStream,
                  builder: (context, snapshot) {
                    return CommonWidget(context).showBackForwardButton(
                      onPressedForward: () => onContinue(snapshot),
                    );
                  },
                ),
                TopInfoLabel(label: ENTER_YOUR_NAME),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.16, vertical: 4.0),
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
                      horizontal: width * 0.16, vertical: 4.0),
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
                emailSection(),
                TopInfoLabel(label: ENTER_YOUR_PHONE_NUMBER),
                phoneNumberField(),
                TopInfoLabel(label: SELECT_BIRTH_DATE),
                dateOfBirthField(),
                TopInfoLabel(label: SELECT_GENDER),
                genderDropDown(),
                SizedBox(height: 25),
              ],
            ),
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
              stream: _signUpBloc.emailVerifiedStream,
              builder: (context, snapshotEmailVerified) {
                return CommonRoundedTextfield(
                  controller: _emailController,
                  suffixIcon: Icon(
                      snapshotEmailVerified.data!
                          ? CupertinoIcons.checkmark_seal_fill
                          : CupertinoIcons.checkmark_seal,
                      size: 18,
                      color: snapshotEmailVerified.data!
                          ? ACCENT_GREEN
                          : DARK_GRAY),
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
                if (_emailController.text.trim().isNotEmpty) {
                  final bool response =
                      await _signUpBloc.sentOtp(_emailController.text);
                  if (response) {
                    ScaffoldSnakBar().show(
                      context,
                      msg: OTP_SENT_TO_POPUP_MSG + ' ${_emailController.text}!',
                    );
                  } else {
                    ScaffoldSnakBar().show(context, msg: FAILED_POPUP_MSG);
                  }
                } else {
                  PlatformAlertDialog()
                      .show(context, title: ALERT, content: 'Email is empty');
                }
              },
            ),
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: _signUpBloc.otpSentStream,
            builder: (context, snapshotSentOtp) {
              return snapshotSentOtp.data!
                  ? CommonRoundedTextfield(
                      hintText: ENTER_OTP_HINT,
                      controller: _otpController,
                      maxLength: 6,
                      onChanged: (val) {
                        if (val.isNotEmpty && val.length == 6)
                          _signUpBloc.verifyEmail(
                              _emailController.text, _otpController.text);
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

  Widget phoneNumberField() {
    return Padding(
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

  Widget dateOfBirthField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: CommonRoundedTextfield(
        controller: _dateController,
        hintText: SELECT_DATE_OF_BIRTH_HINT,
        readOnly: true,
        keyboardType: TextInputType.number,
        onTap: () {
          FocusScope.of(context).unfocus();
          CommonDatepicker()
              .showDatePickerDialog(context, initialDate: _selectedBirthDate)
              .then((pickedDate) {
            if (pickedDate != null && pickedDate != _selectedBirthDate)
              setState(() {
                _selectedBirthDate = pickedDate;
              });
            _dateController.value = TextEditingValue(
                text: DateFormatFromTimeStamp()
                    .dateFormatToYMD(dateTime: _selectedBirthDate));
          });
        },
        validator: (state) {
          if (state!.isEmpty) {
            return 'Please enter date of birth';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget genderDropDown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: DropdownButtonFormField<String>(
          decoration: inputRoundedDecoration(
              getHint: SELCT_GENDER_HINT, isDropDown: true),
          icon: Icon(Icons.expand_more_outlined),
          validator: (val) {
            if (_genderController.text.isEmpty) {
              return 'Select gender want to continue';
            }
            return null;
          },
          isExpanded: true,
          onTap: () => FocusScope.of(context).unfocus(),
          onChanged: (String? newValue) {
            setState(() {
              _genderController.text = newValue!;
            });
          },
          items: gendersItems.map<DropdownMenuItem<String>>((String value) {
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

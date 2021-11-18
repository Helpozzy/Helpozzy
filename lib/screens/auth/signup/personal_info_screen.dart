import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/screens/auth/signup/living_info_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  DateTime _selectedBirthDate = DateTime.now();
  late double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
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
                    TopInfoLabel(label: SELECT_BIRTH_DATE),
                    dateOfBirthField(),
                    TopInfoLabel(label: SELECT_GENDER),
                    genderDropDown(),
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
                  signUpModel.dateOfBirth =
                      _selectedBirthDate.millisecondsSinceEpoch.toString();
                  signUpModel.gender = _genderController.text;
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LivingInfoScreen(signUpModel: signUpModel),
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

  Widget dateOfBirthField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: CommonRoundedTextfield(
        controller: _dateController,
        hintText: BIRTH_DATE_HINT,
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
                text: '${DateFormat.yMd().format(_selectedBirthDate)}');
          });
        },
        validator: (state) {
          if (state!.isEmpty) {
            return 'Please enter date of birth';
          } else {
            return null;
          }
        },
        onChanged: (state) {},
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

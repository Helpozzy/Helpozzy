import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'contact_info.dart';

class LivingInfoScreen extends StatefulWidget {
  LivingInfoScreen({required this.signUpModel});
  final SignUpModel signUpModel;

  @override
  _LivingInfoScreenState createState() =>
      _LivingInfoScreenState(signUpModel: signUpModel);
}

class _LivingInfoScreenState extends State<LivingInfoScreen> {
  _LivingInfoScreenState({required this.signUpModel});
  final SignUpModel signUpModel;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

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
                    TopInfoLabel(label: 'Residential Address'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: CommonRoundedTextfield(
                        controller: _houseNoController,
                        hintText: HOUSE_NO_HINT,
                        validator: (address) {
                          if (address!.isEmpty) {
                            return 'Please enter your house/apt number';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: CommonRoundedTextfield(
                        controller: _streetController,
                        hintText: STREET_NAME_HINT,
                        validator: (address) {
                          if (address!.isEmpty) {
                            return 'Please enter your street name';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    TextFieldWithLabel(
                      controller: _cityController,
                      label: WHICH_CITY,
                      hintText: ENTER_CITY_HINT,
                      validator: (city) {
                        if (city!.isEmpty) {
                          return 'Please enter city';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFieldWithLabel(
                      controller: _stateController,
                      label: WHICH_STATE,
                      hintText: ENTER_STATE_HINT,
                      validator: (state) {
                        if (state!.isEmpty) {
                          return 'Please enter state';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFieldWithLabel(
                      controller: _zipCodeController,
                      keyboardType: TextInputType.number,
                      label: ENTER_ZIP_CODE,
                      maxLength: 6,
                      hintText: ENTER_ZIP_CODE_HINT,
                      validator: (code) {
                        if (code!.isEmpty) {
                          return 'Please enter ZIP code';
                        } else if (code.isNotEmpty && code.length != 6) {
                          return 'Please enter 6 digit code';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
            Container(
              margin: bottomContinueBtnEdgeInsets(width, height),
              width: double.infinity,
              child: CommonButton(
                text: CONTINUE_BUTTON,
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  signUpModel.volunteerType = signUpModel.volunteerType;
                  signUpModel.state = _stateController.text;
                  signUpModel.city = _cityController.text;
                  signUpModel.zipCode = _zipCodeController.text;
                  signUpModel.address =
                      _houseNoController.text + ', ' + _streetController.text;
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContactInfoScreen(signUpModel: signUpModel),
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

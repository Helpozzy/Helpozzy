import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/cities_bloc.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'contact_info.dart';

class LivingInfoScreen extends StatefulWidget {
  LivingInfoScreen({required this.signUpModel});
  final SignUpAndUserModel signUpModel;

  @override
  _LivingInfoScreenState createState() =>
      _LivingInfoScreenState(signUpModel: signUpModel);
}

class _LivingInfoScreenState extends State<LivingInfoScreen> {
  _LivingInfoScreenState({required this.signUpModel});
  final SignUpAndUserModel signUpModel;
  final _formKey = GlobalKey<FormState>();
  final CityInfoBloc _cityInfoBloc = CityInfoBloc();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  late ThemeData _theme;
  late double width;
  late double height;

  @override
  void initState() {
    _cityInfoBloc.getSchools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _theme = Theme.of(context);
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
                    TopInfoLabel(label: WHICH_CITY),
                    StreamBuilder<Cities>(
                      stream: _cityInfoBloc.citiesStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                              color: PRIMARY_COLOR);
                        }
                        final List<CityModel> cities = snapshot.data!.cities;
                        return selectCityGradeDropDown(cities);
                      },
                    ),
                    TopInfoLabel(label: WHICH_STATE),
                    StreamBuilder<Cities>(
                      stream: _cityInfoBloc.citiesStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(
                              color: PRIMARY_COLOR);
                        }
                        final List<CityModel> cities = snapshot.data!.cities;
                        return selectStateGradeDropDown(cities);
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

  Widget selectCityGradeDropDown(List<CityModel> cities) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: DropdownButtonFormField<CityModel>(
          hint: Text(SELECT_CITY_HINT),
          icon: Icon(Icons.expand_more_outlined),
          decoration: inputRoundedDecoration(
              getHint: SELECT_CITY_HINT, isDropDown: true),
          isExpanded: true,
          onChanged: (CityModel? newValue) {
            setState(() {
              _cityController.text = newValue!.stateName!;
            });
          },
          validator: (val) {
            if (_cityController.text.isNotEmpty &&
                _cityController.text == SELECT_CITY_HINT) {
              return 'Please select city';
            }
            return null;
          },
          items: cities.map<DropdownMenuItem<CityModel>>((CityModel? value) {
            return DropdownMenuItem<CityModel>(
              value: value,
              child: Text(
                value!.city!,
                textAlign: TextAlign.center,
                style: _theme.textTheme.bodyText2,
              ),
            );
          }).toList()),
    );
  }

  Widget selectStateGradeDropDown(List<CityModel> cities) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: DropdownButtonFormField<CityModel>(
          hint: Text(SELECT_STATE_HINT),
          icon: Icon(Icons.expand_more_outlined),
          style: TextStyle(),
          decoration: inputRoundedDecoration(
              getHint: SELECT_STATE_HINT, isDropDown: true),
          isExpanded: true,
          onChanged: (CityModel? newValue) {
            setState(() {
              _stateController.text = newValue!.stateName!;
            });
          },
          validator: (val) {
            if (_stateController.text.isNotEmpty &&
                _stateController.text == SELECT_STATE_HINT) {
              return 'Please select state';
            }
            return null;
          },
          items: cities.map<DropdownMenuItem<CityModel>>((CityModel? value) {
            return DropdownMenuItem<CityModel>(
              value: value,
              child: Text(
                value!.stateName!,
                textAlign: TextAlign.center,
                style: _theme.textTheme.bodyText2,
              ),
            );
          }).toList()),
    );
  }
}

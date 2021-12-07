import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/cities_bloc.dart';
import 'package:helpozzy/helper/state_city_helper.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'contact_info.dart';

class LivingInfoScreen extends StatefulWidget {
  LivingInfoScreen({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  @override
  _LivingInfoScreenState createState() =>
      _LivingInfoScreenState(signupAndUserModel: signupAndUserModel);
}

class _LivingInfoScreenState extends State<LivingInfoScreen> {
  _LivingInfoScreenState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;
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
  late List<CityModel>? states = [];
  late List<CityModel>? cities = [];

  @override
  void initState() {
    _cityInfoBloc.getStates();
    listenState();
    super.initState();
  }

  Future listenState() async {
    final StatesHelper statesHelper = await _cityInfoBloc.getStates();
    setState(() => states = statesHelper.states);
  }

  Future listenCities(String stateName) async {
    final Cities citiesList = await _cityInfoBloc.getCities(stateName);
    setState(() => cities = citiesList.cities);
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
                    TopInfoLabel(label: WHICH_STATE),
                    selectStateDropDown(states!),
                    cities!.isNotEmpty ? SizedBox(height: 10) : SizedBox(),
                    selectCitiesDropDown(cities!),
                    TextFieldWithLabel(
                      controller: _zipCodeController,
                      keyboardType: TextInputType.number,
                      label: ENTER_ZIP_CODE,
                      maxLength: 5,
                      hintText: ENTER_ZIP_CODE_HINT,
                      validator: (code) {
                        if (code!.isEmpty) {
                          return 'Please enter ZIP code';
                        } else if (code.isNotEmpty && code.length != 5) {
                          return 'Please enter 5 digit code';
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
                  signupAndUserModel.volunteerType =
                      signupAndUserModel.volunteerType;
                  signupAndUserModel.state = _stateController.text;
                  signupAndUserModel.city = _cityController.text;
                  signupAndUserModel.zipCode = _zipCodeController.text;
                  signupAndUserModel.address =
                      _houseNoController.text + ', ' + _streetController.text;
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactInfoScreen(
                            signupAndUserModel: signupAndUserModel),
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

  Widget selectStateDropDown(List<CityModel> states) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: DropdownButtonFormField<CityModel>(
          hint: Text(states.isEmpty ? 'Loading..' : SELECT_STATE_HINT),
          icon: Icon(Icons.expand_more_outlined),
          decoration: inputRoundedDecoration(
              getHint: SELECT_STATE_HINT, isDropDown: true),
          isExpanded: true,
          onTap: () => FocusScope.of(context).unfocus(),
          onChanged: (CityModel? newValue) async {
            setState(() => _stateController.text = newValue!.stateName!);
            cities!.clear();
            listenCities(newValue!.stateName!);
          },
          validator: (val) {
            if (_stateController.text.isNotEmpty &&
                _stateController.text == SELECT_STATE_HINT) {
              return 'Please select state';
            }
            return null;
          },
          items: states.map<DropdownMenuItem<CityModel>>((CityModel? value) {
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

  Widget selectCitiesDropDown(List<CityModel> cities) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: cities.isNotEmpty
          ? DropdownButtonFormField<CityModel>(
              hint: Text(_stateController.text.isEmpty
                  ? SELECT_CITY_HINT
                  : cities.isEmpty
                      ? 'Loading..'
                      : SELECT_CITY_HINT),
              icon: Icon(Icons.expand_more_outlined),
              decoration: inputRoundedDecoration(
                getHint: SELECT_CITY_HINT,
                isDropDown: true,
              ),
              isExpanded: true,
              onTap: () => FocusScope.of(context).unfocus(),
              onChanged: (CityModel? newValue) {
                setState(() {
                  _cityController.text = newValue!.city!;
                });
              },
              validator: (val) {
                if (_cityController.text.isNotEmpty &&
                    _cityController.text == SELECT_CITY_HINT) {
                  return 'Please select city';
                }
                return null;
              },
              items:
                  cities.map<DropdownMenuItem<CityModel>>((CityModel? value) {
                return DropdownMenuItem<CityModel>(
                  value: value,
                  child: Text(
                    value!.city!,
                    textAlign: TextAlign.center,
                    style: _theme.textTheme.bodyText2,
                  ),
                );
              }).toList())
          : SizedBox(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:helpozzy/bloc/cities_bloc.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/auth/signup/organization_sign_up.dart';
import 'package:helpozzy/screens/auth/signup/6_target_and_area_of_interest.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import '4_contact_info.dart';

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
  final CityBloc _cityInfoBloc = CityBloc();
  // final TextEditingController _stateController = TextEditingController();
  // final TextEditingController _cityController = TextEditingController();
  // final TextEditingController _zipCodeController = TextEditingController();
  // final TextEditingController _houseNoController = TextEditingController();
  // final TextEditingController _streetController = TextEditingController();
  final TextEditingController _addressLocationController =
      TextEditingController();
  late ThemeData _theme;
  late double width;
  late double height;
  late GooglePlace googlePlace;
  late List<AutocompletePrediction> predictions = [];
  late DetailsResult? detailsResult;
  late String? location = '';
  late double latitude = 0.0;
  late double longitude = 0.0;
  late List<StateModel>? states = [];
  late List<CityModel>? cities = [];
  late bool showParentFields = false;

  @override
  void initState() {
    _cityInfoBloc.getStates();
    googlePlace = GooglePlace(ANDROID_MAP_API_KEY);
    // listenState();
    super.initState();
  }

  Future<void> autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() => predictions = result.predictions!);
    }
  }

  Future<void> getDetails(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      detailsResult = result.result!;
      location = detailsResult!.name! + detailsResult!.formattedAddress!;
      latitude = detailsResult!.geometry!.location!.lat!;
      longitude = detailsResult!.geometry!.location!.lng!;
      _addressLocationController.clear();
      predictions.clear();
      setState(() {});
    }
  }

  // Future listenState() async {
  //   final States statesList = await _cityInfoBloc.getStates();
  //   setState(() => states = statesList.states);
  // }

  // Future listenCities(String stateName) async {
  //   final Cities citiesList = await _cityInfoBloc.getCities(stateName);
  //   setState(() => cities = citiesList.cities);
  // }

  Future onContinue() async {
    FocusScope.of(context).unfocus();
    // signupAndUserModel.state = _stateController.text;
    // signupAndUserModel.city = _cityController.text;
    // signupAndUserModel.zipCode = _zipCodeController.text;
    signupAndUserModel.address = location;
    // _houseNoController.text + ', ' + _streetController.text;
    if (_formKey.currentState!.validate()) {
      if (location != null || location!.isNotEmpty) {
        if (signupAndUserModel.isOrganization!) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrganizationSignUp(signupAndUserModel: signupAndUserModel),
            ),
          );
        } else {
          final bool requiredParentInfo = await getAgeFromDOB();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => requiredParentInfo
                  ? ContactInfoScreen(signupAndUserModel: signupAndUserModel)
                  : TargetAndAreaOfInterest(
                      signupAndUserModel: signupAndUserModel),
            ),
          );
        }
      } else {
        ScaffoldSnakBar()
            .show(context, msg: 'Please select location to move forward');
      }
    }
  }

  Future<bool> getAgeFromDOB() async {
    final dateOfBirth = DateTime.fromMillisecondsSinceEpoch(
        int.parse(signupAndUserModel.dateOfBirth!));
    final currentDate = DateTime.now();
    final Duration duration = currentDate.difference(dateOfBirth);
    final int diff = (duration.inDays / 365).floor();
    if (diff > 18)
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _theme = Theme.of(context);
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: SCREEN_BACKGROUND,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CommonWidget(context).showBackForwardButton(
                  onPressedForward: () => onContinue(),
                ),
                TopInfoLabel(label: RESIDENTAL_ADDRESS),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                //   child: CommonRoundedTextfield(
                //     controller: _houseNoController,
                //     hintText: HOUSE_NO_HINT,
                //     validator: (address) {
                //       if (address!.isEmpty) {
                //         return 'Please enter your house/apt number';
                //       } else {
                //         return null;
                //       }
                //     },
                //   ),
                // ),
                // SizedBox(height: 25),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                //   child: CommonRoundedTextfield(
                //     controller: _streetController,
                //     hintText: STREET_NAME_HINT,
                //     validator: (address) {
                //       if (address!.isEmpty) {
                //         return 'Please enter your street name';
                //       } else {
                //         return null;
                //       }
                //     },
                //   ),
                // ),
                // TopInfoLabel(label: WHICH_STATE),
                // selectStateDropDown(states!),
                // cities!.isNotEmpty ? TopInfoLabel(label: WHICH_CITY) : SizedBox(),
                // selectCitiesDropDown(cities!),
                // TextFieldWithLabel(
                //   controller: _zipCodeController,
                //   keyboardType: TextInputType.number,
                //   label: ENTER_ZIP_CODE,
                //   maxLength: 5,
                //   hintText: ENTER_ZIP_CODE_HINT,
                //   validator: (code) {
                //     if (code!.isEmpty) {
                //       return 'Please enter ZIP code';
                //     } else if (code.isNotEmpty && code.length != 5) {
                //       return 'Please enter 5 digit code';
                //     } else {
                //       return null;
                //     }
                //   },
                // ),
                addressLocationSelection(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.06, horizontal: width * 0.1),
                  child: CommonButton(
                    text: CONTINUE_BUTTON,
                    onPressed: () => onContinue(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addressLocationSelection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: CommonRoundedTextfield(
            textAlignCenter: true,
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: PRIMARY_COLOR,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                longitude = 0.0;
                latitude = 0.0;
                predictions.clear();
                _addressLocationController.clear();
                setState(() {});
              },
              icon: Icon(
                Icons.close,
                color: PRIMARY_COLOR,
                size: 20,
              ),
            ),
            // label: PROJECT_LOCATION_LABEL,
            controller: _addressLocationController,
            hintText: PROJECT_LOCATION_HINT,
            validator: (val) => null,

            onChanged: (val) {
              if (val.isNotEmpty) {
                autoCompleteSearch(val);
              } else {
                if (predictions.length > 0 && mounted) {
                  setState(() => predictions = []);
                }
              }
            },
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: predictions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => getDetails(predictions[index].placeId!),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: width * 0.1,
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        predictions[index].description!,
                        maxLines: 3,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        detailsResult != null
            ? Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4.0, horizontal: width * 0.08),
                child: Card(
                  elevation: 0,
                  color: WHITE,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: width * 0.05),
                    title: Text(
                      RESIDENTAL_ADDRESS,
                      style: _theme.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        detailsResult!.name! + detailsResult!.formattedAddress!,
                        style: _theme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: DARK_GRAY,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      CupertinoIcons.map_pin_ellipse,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  // Widget selectStateDropDown(List<StateModel> states) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: width * 0.1),
  //     child: DropdownButtonFormField<StateModel>(
  //         hint: Text(states.isEmpty ? 'Loading..' : SELECT_STATE_HINT),
  //         icon: Icon(Icons.expand_more_outlined),
  //         decoration: inputRoundedDecoration(
  //             getHint: SELECT_STATE_HINT, isDropDown: true),
  //         isExpanded: true,
  //         onTap: () => FocusScope.of(context).unfocus(),
  //         onChanged: (StateModel? newValue) async {
  //           setState(() => _stateController.text = newValue!.stateName!);
  //           cities!.clear();
  //           listenCities(newValue!.stateName!);
  //         },
  //         validator: (val) {
  //           if (val == null) {
  //             return 'Please select state';
  //           }
  //           return null;
  //         },
  //         items: states.map<DropdownMenuItem<StateModel>>((StateModel? value) {
  //           return DropdownMenuItem<StateModel>(
  //             value: value,
  //             child: Text(
  //               value!.stateName!,
  //               textAlign: TextAlign.center,
  //               style: _theme.textTheme.bodyText2,
  //             ),
  //           );
  //         }).toList()),
  //   );
  // }

  // Widget selectCitiesDropDown(List<CityModel> cities) {
  //   return cities.isNotEmpty
  //       ? Padding(
  //           padding: EdgeInsets.symmetric(horizontal: width * 0.1),
  //           child: CommonRoundedTextfield(
  //             textAlignCenter: false,
  //             controller: _cityController,
  //             readOnly: true,
  //             suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
  //             hintText: SELECT_STATE_HINT,
  //             validator: (val) {
  //               if (val == null) {
  //                 return 'Please select city';
  //               }
  //               return null;
  //             },
  //             onTap: () async {
  //               final String city = await SearchCityBottomSheet()
  //                   .showBottomSheet(context, cities: cities);
  //               setState(() => _cityController.text = city);
  //             },
  //           ),
  //         )
  //       : SizedBox();
  // }
}

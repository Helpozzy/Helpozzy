import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/user_model.dart';
import 'package:helpozzy/screens/auth/signup/search_bottomsheets/common_search_bottomsheet.dart';
import 'package:helpozzy/screens/auth/signup/target_and_area_of_interest.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SchoolAndGradeScreen extends StatefulWidget {
  SchoolAndGradeScreen({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;

  @override
  _SchoolAndGradeScreenState createState() =>
      _SchoolAndGradeScreenState(signupAndUserModel: signupAndUserModel);
}

class _SchoolAndGradeScreenState extends State<SchoolAndGradeScreen> {
  _SchoolAndGradeScreenState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  late ThemeData _theme;
  late String stateId = '';
  late double height;
  late double width;

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
            CommonWidget(context).showBackButton(),
            TopInfoLabel(label: SCHOOL_STATE),
            selectStateDropdown(),
            TopInfoLabel(label: SCHOOL_CITY),
            selectCityDropdown(),
            TopInfoLabel(label: SCHOOL_NAME),
            schoolField(),
            TopInfoLabel(label: GRADE_LEVEL),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.10),
              child: selectGradeDropDown(),
            ),
            Spacer(),
            Container(
              margin: bottomContinueBtnEdgeInsets(width, height),
              width: double.infinity,
              child: CommonButton(
                text: CONTINUE_BUTTON,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  signupAndUserModel.schoolName = _schoolController.text;
                  signupAndUserModel.gradeLevel = _gradeLevelController.text;
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TargetAndAreaOfInterest(
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

  Widget selectStateDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: CommonRoundedTextfield(
        textAlignCenter: false,
        controller: _stateController,
        readOnly: true,
        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
        hintText: SELECT_STATE_HINT,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please select state';
          }
          return null;
        },
        onTap: () async {
          final StateModel model =
              await SearchBottomSheet().modalBottomSheetMenu(
            context: context,
            searchBottomSheetType: SearchBottomSheetType.STATE_BOTTOMSHEET,
            state: '',
            city: '',
          );
          setState(() {
            _stateController.text = model.stateName!;
            stateId = model.stateId!;
          });
        },
      ),
    );
  }

  Widget selectCityDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: CommonRoundedTextfield(
        textAlignCenter: false,
        controller: _cityController,
        readOnly: true,
        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
        hintText: SELECT_CITY_HINT,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please select city';
          }
          return null;
        },
        onTap: () async {
          final String city = await SearchBottomSheet().modalBottomSheetMenu(
            context: context,
            searchBottomSheetType: SearchBottomSheetType.CITY_BOTTOMSHEET,
            state: stateId,
            city: '',
          );
          setState(() {
            _cityController.text = city;
          });
        },
      ),
    );
  }

  Widget schoolField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: CommonRoundedTextfield(
        textAlignCenter: false,
        controller: _schoolController,
        readOnly: true,
        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
        hintText: SELECT_SCHOOL_HINT,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please select school';
          }
          return null;
        },
        onTap: () async {
          final SchoolDetailsModel school = await SearchBottomSheet()
              .modalBottomSheetMenu(
                  context: context,
                  searchBottomSheetType:
                      SearchBottomSheetType.SCHOOL_BOTTOMSHEET,
                  state: stateId,
                  city: _cityController.text);
          setState(() {
            _schoolController.text = school.schoolName;
          });
        },
      ),
    );
  }

  Widget selectGradeDropDown() {
    return DropdownButtonFormField<String>(
        hint: Text(SELECT_GRADE_HINT),
        icon: Icon(Icons.expand_more_outlined),
        decoration: inputRoundedDecoration(
            getHint: SELECT_GRADE_HINT, isDropDown: true),
        isExpanded: true,
        onChanged: (String? newValue) {
          setState(() {
            _gradeLevelController.text = newValue!;
          });
        },
        validator: (val) {
          if (_gradeLevelController.text.isEmpty) {
            return 'Please select grade level';
          }
          return null;
        },
        items: gradeLevels.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: _theme.textTheme.bodyText2,
            ),
          );
        }).toList());
  }
}

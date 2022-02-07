import 'package:flutter/material.dart';
import 'package:helpozzy/models/cities_model.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/user_model.dart';
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
  final _formKey = GlobalKey<FormState>();
  late ThemeData _theme;
  late String stateId = '';
  late double height;
  late double width;
  late List<StateModel> statesList = [];
  late List<String> citiesList = [];
  late List<SchoolDetailsModel> schoolsList = [];

  Future onContinue() async {
    FocusScope.of(context).unfocus();
    signupAndUserModel.schoolName = _schoolController.text;
    signupAndUserModel.gradeLevel = _gradeLevelController.text;
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TargetAndAreaOfInterest(signupAndUserModel: signupAndUserModel),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: SCREEN_BACKGROUND,
      body: GestureDetector(
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CommonWidget(context).showBackForwardButton(
                  onPressedForward: () => onContinue(),
                ),
                TopInfoLabel(label: SCHOOL_STATE),
                selectStateDropdown(),
                TopInfoLabel(label: SCHOOL_CITY),
                selectCityDropdown(),
                TopInfoLabel(label: SCHOOL_NAME),
                schoolField(),
                TopInfoLabel(label: GRADE_LEVEL),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.10),
                  child: selectGradeDropDown(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectStateDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: CommonRoundedTextfield(
        controller: _stateController,
        hintText: SEARCH_STATE_NAME_HINT,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter state';
          }
          return null;
        },
        onChanged: (value) {},
      ),
    );
  }

  Widget selectCityDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: CommonRoundedTextfield(
        controller: _cityController,
        hintText: SEARCH_CITY_NAME_HINT,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter city';
          }
          return null;
        },
        onChanged: (value) {},
      ),
    );
  }

  Widget schoolField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: CommonRoundedTextfield(
        controller: _schoolController,
        hintText: SEARCH_SCHOOL_HINT,
        onChanged: (value) {},
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please select school';
          }
          return null;
        },
      ),
    );
  }

  Widget selectGradeDropDown() {
    return DropdownButtonFormField<String>(
      icon: Icon(Icons.expand_more_outlined),
      decoration: inputRoundedDecoration(
        getHint: SELECT_GRADE_HINT,
        isDropDown: true,
      ),
      isExpanded: true,
      onChanged: (String? newValue) {
        setState(() => _gradeLevelController.text = newValue!);
      },
      validator: (val) {
        if (val == null) {
          return 'Please select grade';
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
      }).toList(),
    );
  }
}

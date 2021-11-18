import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/bloc/school_info_bloc.dart';
import 'package:helpozzy/models/school_model.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/screens/auth/signup/area_of_interest.dart';
import 'package:helpozzy/screens/auth/signup/search_school.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class SchoolAndGradeScreen extends StatefulWidget {
  SchoolAndGradeScreen({required this.signUpModel});
  final SignUpModel signUpModel;

  @override
  _SchoolAndGradeScreenState createState() =>
      _SchoolAndGradeScreenState(signUpModel: signUpModel);
}

class _SchoolAndGradeScreenState extends State<SchoolAndGradeScreen> {
  _SchoolAndGradeScreenState({required this.signUpModel});
  final SignUpModel signUpModel;

  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  final SchoolsInfoBloc _schoolsInfoBloc = SchoolsInfoBloc();
  late ThemeData _theme;

  @override
  void initState() {
    // _schoolsInfoBloc.postSchools(schools);
    _schoolsInfoBloc.getSchools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: SCREEN_BACKGROUND,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CommonWidget(context).showBackButton(),
            TopInfoLabel(label: SCHOOL_NAME),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: CommonRoundedTextfield(
                textAlignCenter: false,
                controller: _schoolController,
                readOnly: true,
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                hintText: SELECT_SCHOOL_HINT,
                validator: (val) {
                  if (val!.isNotEmpty && val == SELECT_SCHOOL_HINT) {
                    return 'Please select school';
                  }
                  return null;
                },
                onTap: () async {
                  final SchoolDetailsModel school =
                      await SearchSchool().modalBottomSheetMenu(context);
                  setState(() {
                    _schoolController.text = school.schoolName;
                  });
                },
              ),
            ),
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
                  signUpModel.schoolName = _schoolController.text;
                  signUpModel.gradeLevel = _gradeLevelController.text;
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AreaOfInterest(signUpModel: signUpModel),
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
          if (_gradeLevelController.text.isNotEmpty &&
              _gradeLevelController.text == SELECT_GRADE_HINT) {
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

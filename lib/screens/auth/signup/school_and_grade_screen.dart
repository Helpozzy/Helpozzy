import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/screens/auth/signup/password_set_screen.dart';
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
  late ThemeData _theme;

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
                controller: _schoolController,
                hintText: ENTER_SCHOOL_HINT,
                validator: (state) {
                  if (state!.isEmpty) {
                    return 'Please enter your school';
                  } else {
                    return null;
                  }
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
                            PasswordSetScreen(signUpModel: signUpModel),
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
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      child: DropdownButtonFormField<String>(
          hint: Text(SELECT_GRADE_HINT),
          icon: Icon(Icons.expand_more_outlined),
          decoration: inputRoundedDecoration(
              getHint: SELECT_RELATION_HINT, isDropDown: true),
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              _gradeLevelController.text = newValue!;
            });
          },
          validator: (val) {
            if (_gradeLevelController.text.isNotEmpty &&
                _gradeLevelController.text == SELECT_RELATION_HINT) {
              return 'Select grade level';
            }
            return null;
          },
          items: gradeLevels.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: _theme.textTheme.bodyText2,
                ),
              ),
            );
          }).toList()),
    );
  }
}

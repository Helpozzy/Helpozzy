import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/screens/auth/signup/phone_with_parent_guardian_number.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_date_time_picker.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';
import 'package:intl/intl.dart';

class BirthDateScreen extends StatefulWidget {
  BirthDateScreen({required this.signUpModel});
  final SignUpModel signUpModel;

  @override
  _BirthDateScreenState createState() =>
      _BirthDateScreenState(signUpModel: signUpModel);
}

class _BirthDateScreenState extends State<BirthDateScreen> {
  _BirthDateScreenState({required this.signUpModel});
  final SignUpModel signUpModel;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _dialogKey = GlobalKey<State>();

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
            CommonWidget(context).showBackButton(),
            TopInfoLabel(label: SELECT_BIRTH_DATE),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: CommonRoundedTextfield(
                controller: _dateController,
                hintText: BIRTH_DATE_HINT,
                readOnly: true,
                keyboardType: TextInputType.number,
                onTap: () {
                  CommonDatepicker()
                      .showDatePickerDialog(context, initialDate: _selectedDate)
                      .then((pickedDate) {
                    if (pickedDate != null && pickedDate != _selectedDate)
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    _dateController.value = TextEditingValue(
                        text: '${DateFormat.yMd().format(_selectedDate)}');
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
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(
                  left: width * 0.15,
                  right: width * 0.15,
                  bottom: height * 0.03),
              width: double.infinity,
              child: CommonButton(
                text: CONTINUE_BUTTON,
                onPressed: () {
                  onSubmit();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    signUpModel.dateOfBirth = _selectedDate.millisecondsSinceEpoch.toString();
    final currentDate = DateTime.now();

    if (_selectedDate != currentDate) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PhoneWithParentGuardianNumber(signUpModel: signUpModel),
        ),
      );
    } else {
      PlatformAlertDialog().show(
        context,
        _dialogKey,
        title: ALERT,
        content: 'Please select your DOB',
      );
    }
  }
}

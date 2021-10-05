import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class UserTypeSelection extends StatefulWidget {
  @override
  _UserTypeSelectionState createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SCREEN_BACKGROUND,
      body: SingleChildScrollView(
        child: UserSelection(),
      ),
    );
  }
}

class UserSelection extends StatefulWidget {
  @override
  State<UserSelection> createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  final _formKey = GlobalKey<FormState>();
  String modeDropdownValue = SELECT_TYPE_HINT;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.15, bottom: height * 0.10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopAppLogo(height: height / 6),
            TopInfoLabel(label: SELECT_USER_TYPE),
            selectUserTypeDropdown(),
            Container(
              margin: buildEdgeInsetsCustom(width, 0.20, 20.0, 0.20, 15.0),
              width: double.infinity,
              child: CommonButton(
                text: CONTINUE_BUTTON.toUpperCase(),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (modeDropdownValue == 'User') {
                      Navigator.pushNamed(context, SIGNUP);
                    } else if (modeDropdownValue == 'Admin') {
                      Navigator.pushNamed(context, ADMIN_SELECTION);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectUserTypeDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      padding: EdgeInsets.only(left: 20, right: 10),
      child: DropdownButtonFormField<String>(
          value: modeDropdownValue,
          decoration: inputRoundedDecoration(getHint: SELECT_TYPE_HINT),
          icon: Icon(Icons.expand_more_outlined),
          validator: (val) {
            if (val!.isNotEmpty && val == SELECT_TYPE_HINT) {
              return 'Select user want to continue';
            }
            return null;
          },
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              modeDropdownValue = newValue!;
            });
          },
          items: loginModes.map<DropdownMenuItem<String>>((String value) {
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

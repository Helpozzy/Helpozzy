import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpozzy/models/signup_model.dart';
import 'package:helpozzy/screens/user/auth/signup/residential_address.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';

class PhoneWithParentGuardianNumber extends StatefulWidget {
  PhoneWithParentGuardianNumber({required this.signUpModel});
  final SignUpModel signUpModel;

  @override
  _PhoneWithParentGuardianNumberState createState() =>
      _PhoneWithParentGuardianNumberState();
}

class _PhoneWithParentGuardianNumberState
    extends State<PhoneWithParentGuardianNumber> {
  final TextEditingController _personalPhoneController =
      TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _dialogKey = GlobalKey<State>();
  final TextEditingController _parentPhoneController = TextEditingController();
  String dropdownValue = SELECT_RELATION_HINT;
  CountryCode? countryCodePersonal;
  CountryCode? countryCodeParent;
  late double width;
  late double height;

  @override
  void initState() {
    countryCodePersonal = CountryCode(code: '+1', name: 'US');
    countryCodeParent = CountryCode(code: '+1', name: 'US');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
                    TopInfoLabel(label: DO_YOU_HAVE_NUMBER),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: CommonTextfield(
                        controller: _personalPhoneController,
                        prefixIcon: countryCodePicker(true),
                        hintText: ENTER_PHONE_NUMBER_HINT,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        validator: (phone) {
                          if (phone!.isEmpty) {
                            return 'Please enter phone number';
                          } else if (phone.isNotEmpty && phone.length != 10) {
                            return 'Please enter 10 digit number';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    TopInfoLabel(label: ENTER_PARENT_NUMBER),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: CommonTextfield(
                        controller: _parentPhoneController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        hintText: ENTER_PHONE_NUMBER_HINT,
                        prefixIcon: countryCodePicker(false),
                        validator: (parentPhone) {
                          if (parentPhone!.isEmpty) {
                            return 'Please enter parents/guardian phone number';
                          } else if (parentPhone.isNotEmpty &&
                              parentPhone.length != 10) {
                            return 'Please enter 10 digit number';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    TextfieldLabelSmall(label: RELATIONSHIP_STATUS),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.10),
                      child: selectRelationshipDropdown(),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: width * 0.15,
                  right: width * 0.15,
                  bottom: height * 0.03),
              width: double.infinity,
              child: CommonButton(
                text: CONTINUE_BUTTON,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Map<String, dynamic> json;
                  json = widget.signUpModel.fromModelToMap();
                  json['personal_phn_no'] = countryCodePersonal!.code! +
                      _personalPhoneController.text;
                  json['parent_phn_no'] =
                      countryCodeParent!.code! + _parentPhoneController.text;
                  json['relationship_with_parent'] = dropdownValue;
                  if (_formKey.currentState!.validate()) {
                    if (dropdownValue != SELECT_RELATION_HINT) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResidentialAddress(
                            signUpModel: SignUpModel.fromJson(json: json),
                          ),
                        ),
                      );
                    } else {
                      PlatformAlertDialog().show(context, _dialogKey,
                          title: ALERT,
                          content: 'Please select relationship status');
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

  Widget countryCodePicker(bool fromPersonal) {
    return CountryCodePicker(
      onChanged: (CountryCode code) {
        if (fromPersonal) {
          countryCodePersonal = code;
        } else {
          countryCodeParent = code;
        }
      },
      boxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      initialSelection: 'US',
      padding: EdgeInsets.only(left: width * 0.05),
      showCountryOnly: false,
      dialogTextStyle: Theme.of(context).textTheme.bodyText2,
      flagWidth: 25.0,
      showOnlyCountryWhenClosed: false,
      showFlag: false,
      showFlagDialog: true,
      favorite: ['+1', 'US'],
      textStyle: Theme.of(context).textTheme.bodyText2,
      closeIcon: Icon(Icons.close_rounded),
      searchDecoration: inputDecoration(getHint: SEARCH_COUNTRY_HINT),
    );
  }

  Widget selectRelationshipDropdown() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.expand_more_outlined),
          underline: SizedBox(),
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: relationShips.map<DropdownMenuItem<String>>((String value) {
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

import 'package:flutter/material.dart';
import 'package:helpozzy/models/organization_sign_up_model.dart';
import 'package:helpozzy/models/sign_up_user_model.dart';
import 'package:helpozzy/screens/auth/signup/7_password_set_screen.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class OrganizationSignUp extends StatefulWidget {
  const OrganizationSignUp({Key? key, required this.signupAndUserModel})
      : super(key: key);
  final SignUpAndUserModel signupAndUserModel;
  @override
  _OrganizationSignUpState createState() =>
      _OrganizationSignUpState(signupAndUserModel: signupAndUserModel);
}

class _OrganizationSignUpState extends State<OrganizationSignUp> {
  _OrganizationSignUpState({required this.signupAndUserModel});
  final SignUpAndUserModel signupAndUserModel;
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _organizationNameController =
      TextEditingController();
  final TextEditingController _organizationDiscriptionContntroller =
      TextEditingController();
  final TextEditingController _organizationOtherContntroller =
      TextEditingController();
  final TextEditingController _organizationEmailContntroller =
      TextEditingController();
  final TextEditingController _organizationTaxIdNumberContntroller =
      TextEditingController();
  late OrganizationTypes _organizationType = OrganizationTypes.CORP;
  late ThemeData _theme;
  late double width;
  late double height;
  late bool nonProfitOrganization = false;

  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: 'XX_XXXXXXX',
    filter: {'X': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  Future onContinue() async {
    FocusScope.of(context).unfocus();
    final OrganizationSignUpModel organizationSignUpModel =
        OrganizationSignUpModel(
      isNonProfitOrganization: nonProfitOrganization,
      legalOrganizationName: _organizationNameController.text,
      discription: _organizationDiscriptionContntroller.text,
      organizationType: _organizationType.index == 0
          ? LLC_RADIO
          : _organizationType.index == 1
              ? PARTNERSHIP_RADIO
              : _organizationType.index == 2
                  ? CORP_RADIO
                  : SOLE_PROP_RADIO,
      other: _organizationOtherContntroller.text,
      otherAdmins: [],
      taxIdNumber: _organizationTaxIdNumberContntroller.text,
    );
    signupAndUserModel.organizationDetails = organizationSignUpModel;

    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SetPasswordScreen(signupAndUserModel: signupAndUserModel),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: SCREEN_BACKGROUND,
      body: body,
    );
  }

  Widget get body => GestureDetector(
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CommonWidget(context).showBackForwardButton(
                  onPressedForward: () async => await onContinue(),
                ),
                TopInfoLabel(label: ORAGANIZATION_SIGN_UP_LABEL),
                textfieldLabel(LEGAL_ORGANIZATION_NAME_LABEL),
                organizationName(),
                textfieldLabel(ORAGANIZATION_DISCRIPTION_LABEL),
                organizationDiscription(),
                textfieldLabel(ORAGANIZATION_TYPE_LABEL),
                organizationTypes(),
                textfieldLabel(OTHER_LABEL),
                organizationOtherType(),
                textfieldLabel(TAX_ID_NUMBER_LABEL),
                taxIdNumber(),
                // textfieldLabel(INVITE_OTHER_ADMIN_LABEL),
                // inviteOtherMember(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: width * 0.06,
                    horizontal: width * 0.07,
                  ),
                  child: CommonButton(
                    text: CONTINUE_BUTTON,
                    onPressed: () async => await onContinue(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget textfieldLabel(String label) => Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: width * 0.12,
          right: width * 0.12,
          top: width * 0.07,
          bottom: 6.0,
        ),
        child: Text(
          label,
          style: _theme.textTheme.bodyText2!.copyWith(
            fontWeight: FontWeight.bold,
            color: PRIMARY_COLOR,
          ),
        ),
      );

  Widget organizationName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: CommonRoundedTextfield(
        controller: _organizationNameController,
        hintText: ORGANIZATION_NAME_HINT,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter organization name';
          }
          return null;
        },
      ),
    );
  }

  Widget organizationDiscription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: CommonRoundedTextfield(
        controller: _organizationDiscriptionContntroller,
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        hintText: ORGANIZATION_DISCRIPTION_HINT,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter organization discription';
          }
          return null;
        },
      ),
    );
  }

  Widget organizationTypes() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RadioTile(
                    label: CORP_RADIO,
                    widget: Radio(
                      value: OrganizationTypes.CORP,
                      groupValue: _organizationType,
                      onChanged: (OrganizationTypes? value) {
                        setState(() => _organizationType = value!);
                      },
                    ),
                  ),
                  RadioTile(
                    label: LLC_RADIO,
                    widget: Radio(
                      value: OrganizationTypes.LLC,
                      groupValue: _organizationType,
                      onChanged: (OrganizationTypes? value) {
                        setState(() => _organizationType = value!);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RadioTile(
                    label: PARTNERSHIP_RADIO,
                    widget: Radio(
                      value: OrganizationTypes.PARTNERSHIP,
                      groupValue: _organizationType,
                      onChanged: (OrganizationTypes? value) {
                        setState(() => _organizationType = value!);
                      },
                    ),
                  ),
                  RadioTile(
                    label: SOLE_PROP_RADIO,
                    widget: Radio(
                      value: OrganizationTypes.SOLE_PROP,
                      groupValue: _organizationType,
                      onChanged: (OrganizationTypes? value) {
                        setState(() => _organizationType = value!);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: nonProfitOrganization,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              onChanged: (val) {
                setState(() => nonProfitOrganization = val!);
              },
            ),
            Text(
              NON_PROFIT_ORGANIZATION_CHECKBOX,
              style: _theme.textTheme.bodyText2!.copyWith(
                color: DARK_GRAY,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget organizationOtherType() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: CommonRoundedTextfield(
        controller: _organizationOtherContntroller,
        hintText: ENTER_STRUCTURE_HINT,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter structure';
          }
          return null;
        },
      ),
    );
  }

  Widget taxIdNumber() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: CommonRoundedTextfield(
        controller: _organizationTaxIdNumberContntroller,
        hintText: TAX_ID_NUM_HINT,
        keyboardType: TextInputType.number,
        inputFormatters: [maskFormatter],
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please enter tax id number';
          }
          return null;
        },
      ),
    );
  }

  Widget inviteOtherMember() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CommonRoundedTextfield(
                  controller: _organizationEmailContntroller,
                  hintText: INVITEES_EMAIL_ADDRESS_HINT,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter Invitees/Admins';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 10),
              Text(
                '0/3',
                style: _theme.textTheme.bodyText2!
                    .copyWith(fontWeight: FontWeight.w600, color: DARK_GRAY),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: SmallCommonButtonWithIcon(
              fontSize: 14,
              iconSize: 14,
              text: ADD_NEW_ADMIN,
              icon: Icons.add,
              onPressed: () async => await onContinue(),
            ),
          )
        ],
      ),
    );
  }
}

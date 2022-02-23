import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class OrganizationSignUp extends StatefulWidget {
  const OrganizationSignUp({Key? key}) : super(key: key);

  @override
  _OrganizationSignUpState createState() => _OrganizationSignUpState();
}

class _OrganizationSignUpState extends State<OrganizationSignUp> {
  static final _formKey = GlobalKey<FormState>();
  final TextEditingController _organizationNameContntroller =
      TextEditingController();
  late OrganizationTypes _organizationType = OrganizationTypes.CORP;
  late ThemeData _theme;
  late double width;
  late double height;
  late bool nonProfitOrganization = false;

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
                  onPressedForward: () {},
                ),
                TopInfoLabel(label: 'Oraganization Sign Up'),
                textfieldLabel('Legal Oraganization Name'),
                organizationName(),
                textfieldLabel('Oraganization Discription'),
                organizationDiscription(),
                textfieldLabel('Organization Type'),
                organizationTypes(),
                textfieldLabel('Other'),
                organizationOtherType(),
                textfieldLabel('Tax ID Number'),
                taxIdNumber(),
                textfieldLabel('Invite Other Admin'),
                inviteOtherMember(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: width * 0.06,
                    horizontal: width * 0.07,
                  ),
                  child: CommonButton(
                    text: CONTINUE_BUTTON,
                    onPressed: () {},
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
        controller: _organizationNameContntroller,
        hintText: 'Organization Name',
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
        controller: _organizationNameContntroller,
        hintText: 'Organization Description',
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
                    label: 'Corp.',
                    widget: Radio(
                      value: OrganizationTypes.CORP,
                      groupValue: _organizationType,
                      onChanged: (OrganizationTypes? value) {
                        setState(() => _organizationType = value!);
                      },
                    ),
                  ),
                  RadioTile(
                    label: 'LLC',
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
                    label: 'Partnership',
                    widget: Radio(
                      value: OrganizationTypes.PARTNERSHIP,
                      groupValue: _organizationType,
                      onChanged: (OrganizationTypes? value) {
                        setState(() => _organizationType = value!);
                      },
                    ),
                  ),
                  RadioTile(
                    label: 'Sole Prop.',
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
              onChanged: (val) {
                setState(() => nonProfitOrganization = val!);
              },
            ),
            Text(
              'Are You A Non-profit Organization?',
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
        controller: _organizationNameContntroller,
        hintText: 'Enter Structure',
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
      child: Row(
        children: [
          Expanded(
            child: CommonRoundedTextfield(
              controller: _organizationNameContntroller,
              hintText: 'XX_XXXXXXX',
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter tax id number';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 10),
          Text(
            '0/9',
            style: _theme.textTheme.bodyText2!
                .copyWith(fontWeight: FontWeight.w600, color: DARK_GRAY),
          ),
        ],
      ),
    );
  }

  Widget inviteOtherMember() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: Row(
        children: [
          Expanded(
            child: CommonRoundedTextfield(
              controller: _organizationNameContntroller,
              hintText: 'Email Adress',
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
    );
  }
}

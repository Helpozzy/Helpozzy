import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';

class AgreementScreen extends StatefulWidget {
  AgreementScreen({required this.isPrivacyPolicy});
  final bool isPrivacyPolicy;
  @override
  State<AgreementScreen> createState() =>
      _AgreementScreenState(isPrivacyPolicy: isPrivacyPolicy);
}

class _AgreementScreenState extends State<AgreementScreen> {
  _AgreementScreenState({required this.isPrivacyPolicy});
  final bool isPrivacyPolicy;
  late ThemeData _theme;
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
      appBar: CommonAppBar(context).show(
        elevation: 0,
        backgroundColor: SCREEN_BACKGROUND,
        title:
            isPrivacyPolicy ? PRIVACY_POLICY_LABEL : TERMS_AND_CONDITION_LABEL,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            isPrivacyPolicy ? PRIVACY_POLICY_CONTENT : TERMS_CONDITION_CONTENT,
            style: _theme.textTheme.bodyText2!.copyWith(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

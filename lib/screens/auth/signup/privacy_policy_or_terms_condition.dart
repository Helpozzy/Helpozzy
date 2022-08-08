import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: SCREEN_BACKGROUND,
      appBar: CommonAppBar(context).show(
        elevation: 0,
        backgroundColor: SCREEN_BACKGROUND,
        title: PRIVACY_POLICY_LABEL,
      ),
      body: WebView(
        initialUrl: 'https://www.helpingforgood.org/about-us/privacy-policy',
      ),
    );
  }
}

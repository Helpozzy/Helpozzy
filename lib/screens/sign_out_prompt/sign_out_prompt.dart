import 'package:flutter/material.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/common_widget.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';
import 'package:provider/provider.dart';

class FullScreenSignOutPrompt extends StatefulWidget {
  @override
  State<FullScreenSignOutPrompt> createState() =>
      _FullScreenSignOutPromptState();
}

class _FullScreenSignOutPromptState extends State<FullScreenSignOutPrompt> {
  late ThemeData _theme;
  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    Future.delayed(Duration.zero, () => showAlert(context));
    return SizedBox();
  }

  void showAlert(BuildContext context) {
    PlatformAlertDialog().showWithAction(
      context,
      title: SIGN_OUT_TITLE,
      content: SIGN_OUT_FROM_APP,
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await Navigator.pushNamedAndRemoveUntil(
                context, HOME_SCREEN, (route) => false);
          },
          child: Text(
            CANCEL_BUTTON,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w600,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: SmallCommonButton(
            fontSize: 12,
            onPressed: () {
              Provider.of<AuthBloc>(context, listen: false).add(AppLogout());
              prefsObject.clear();
              prefsObject.reload();
              Navigator.pushNamedAndRemoveUntil(
                  context, INTRO, (route) => false);
            },
            text: SIGN_OUT_BUTTON,
          ),
        ),
      ],
    );
  }
}

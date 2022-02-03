import 'package:flutter/material.dart';
import 'package:helpozzy/screens/auth/bloc/auth_bloc.dart';
import 'package:helpozzy/utils/constants.dart';
import 'package:helpozzy/widget/platform_alert_dialog.dart';
import 'package:provider/provider.dart';

class FullScreenSignOutDialog extends StatefulWidget {
  @override
  State<FullScreenSignOutDialog> createState() =>
      _FullScreenSignOutDialogState();
}

class _FullScreenSignOutDialogState extends State<FullScreenSignOutDialog> {
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
      title: 'Sign Out',
      content: 'You want to sign out from app!',
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<AuthBloc>(context, listen: false).add(AppLogout());
            prefsObject.clear();
            prefsObject.reload();
            Navigator.pushNamedAndRemoveUntil(context, INTRO, (route) => false);
          },
          child: Text(
            SIGN_OUT_BUTTON,
            style: _theme.textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.w600,
              color: MARUN,
            ),
          ),
        ),
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
      ],
    );
  }
}

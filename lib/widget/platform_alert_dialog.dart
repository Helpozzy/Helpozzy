import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class PlatformAlertDialog {
  Future<dynamic> show(BuildContext context,
      {required String title, required String content}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          elevation: 1,
          backgroundColor: SCREEN_BACKGROUND,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.w800),
          ),
          content: Text(
            content,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          actions: [
            TextButton(
              child: Text(
                OK_BUTTON,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: MARUN),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showWithAction(BuildContext context,
      {required String title,
      required String content,
      required List<Widget>? actions}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          elevation: 1,
          backgroundColor: SCREEN_BACKGROUND,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.w800),
          ),
          content: Text(
            content,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          actions: actions,
        );
      },
    );
  }
}

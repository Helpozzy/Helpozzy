import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class PlatformAlertDialog {
  Future<dynamic> show(BuildContext context,
      {required String title, required String content}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: SCREEN_BACKGROUND,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

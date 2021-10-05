import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class CommonDatepicker {
  Future<DateTime?> showPicker(BuildContext context,
      {required DateTime initialDate}) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: PRIMARY_COLOR,
              onPrimary: Colors.white,
              onSurface: PRIMARY_COLOR,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: PRIMARY_COLOR),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

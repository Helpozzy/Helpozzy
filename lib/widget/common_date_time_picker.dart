import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class CommonDatepicker {
  Future<DateTime?> showDatePickerDialog(BuildContext context,
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

  Future<TimeOfDay?> showTimePickerDialog(BuildContext context,
      {required TimeOfDay selectedTime}) async {
    return showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: PRIMARY_COLOR,
              onSurface: PRIMARY_COLOR,
            ),
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(primary: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

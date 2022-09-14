import 'package:flutter/material.dart';
import 'package:helpozzy/utils/constants.dart';

class CommonDatepicker {
  Future<DateTime?> showDatePickerDialog(
    BuildContext context, {
    DateTime? previousDate,
    DateTime? initialDate,
  }) async {
    final DateTime currentDate = DateTime.now();
    final DateTime lastDate = DateTime(currentDate.year, currentDate.month + 3);
    return showDatePicker(
      context: context,
      initialDate: initialDate != null ? initialDate : currentDate,
      firstDate: previousDate != null ? previousDate : currentDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: PRIMARY_COLOR,
              onPrimary: Colors.white,
              onSurface: PRIMARY_COLOR,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(backgroundColor: WHITE),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

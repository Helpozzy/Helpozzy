import 'package:intl/intl.dart';

class DateFormatFromTimeStamp {
  String dateFormatToEEEDDMMMYYYY({required String timeStamp}) =>
      DateFormat('EEE, dd MMM - yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)),
      );
  String dateFormatToEEEDDMMMYYYYatTime({required String timeStamp}) =>
      DateFormat('EEE, dd MMM - yyyy, hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)),
      );
  String dateFormatToYMD({required DateTime dateTime}) =>
      DateFormat.yMd().format(dateTime);

  String dateFormatToMMMYYYY({required String timeStamp}) =>
      DateFormat('MMM, yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)),
      );

  String dateYearYYYY({required String timestamp}) => DateFormat('yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)),
      );

  String dateMonthMMM({required String timestamp}) => DateFormat('MMM').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)),
      );

  List<String> getMonths(int year) {
    final List<String> months = [];
    final DateFormat formatter = DateFormat('MMM');
    final DateTime date = DateTime(year);

    for (int i = 0; i < 12; i++) {
      DateTime month = DateTime(date.year, date.month - i);
      String monthName = formatter.format(month);
      months.add(monthName);
    }
    return months;
  }

  List<String> getYear() {
    final List<String> months = [];
    final DateFormat formatter = DateFormat('yyyy');
    final DateTime date = DateTime.now();

    for (int i = 0; i < 6; i++) {
      DateTime year = DateTime(date.year - i);
      String yearYYYY = formatter.format(year);
      months.add(yearYYYY);
    }
    return months;
  }
}

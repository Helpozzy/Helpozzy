import 'package:intl/intl.dart';

class DateFormatFromTimeStamp {
  String dateFormatToEEEDDMMMYYYY({required String timeStamp}) =>
      DateFormat('EEE, dd MMM - yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)),
      );

  String dateFormatToYMD({required DateTime dateTime}) =>
      DateFormat.yMd().format(dateTime);

  String dateFormatToMMMYYYY({required String timeStamp}) =>
      DateFormat('MMM yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)),
      );

  List<String> getPreviousSixMonths() {
    final List<String> lastFiveMonth = [];
    final DateFormat formatter = DateFormat('MMM');
    final DateTime date = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime month = DateTime(date.year, date.month - i);
      String monthName = formatter.format(month);
      lastFiveMonth.add(monthName);
    }
    return lastFiveMonth;
  }
}

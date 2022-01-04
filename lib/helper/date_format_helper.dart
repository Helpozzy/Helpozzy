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

  int getLastMonth() {
    return int.parse(
        DateFormat('MM').format(DateTime.now().subtract(Duration(days: 30))));
  }
}

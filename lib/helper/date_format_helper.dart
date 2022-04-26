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

  String dateFormatToDDMMMYYYYatTime({required String timeStamp}) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(
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

  String dateYYYY({required String timestamp}) => DateFormat.y().format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)),
      );

  String durationToHHMM({required Duration duration}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours.remainder(60));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return '$twoDigitHours:$twoDigitMinutes';
  }

  List<String> getMonthsFromYear(int year) {
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

  List<String> getYears() {
    final List<String> years = [];
    final DateFormat formatter = DateFormat('yyyy');
    final DateTime date = DateTime.now();

    for (int i = 0; i < 6; i++) {
      DateTime year = DateTime(date.year - i);
      String yearYYYY = formatter.format(year);
      years.add(yearYYYY);
    }
    return years;
  }

  String getPastTimeFromCurrent(String timeStamp) {
    final DateTime lastSeen =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    final DateTime currentDateTime = DateTime.now();

    Duration diff = currentDateTime.difference(lastSeen);

    late String lastseen = '';
    if (diff.inDays == 0 && diff.inHours == 0 && diff.inMinutes == 0) {
      lastseen = 'Active now';
    } else if (diff.inDays == 0 && diff.inHours == 0 && diff.inMinutes <= 60) {
      lastseen = '${diff.inMinutes} mins ago';
    } else if (diff.inDays == 0 && diff.inHours <= 12) {
      lastseen = '${diff.inHours} hrs ago';
    } else if (diff.inDays == 0) {
      lastseen = 'Active today';
    } else if (diff.inDays == 1) {
      lastseen = 'Active yesterday';
    } else if (diff.inDays == 2) {
      lastseen = 'Last active 2 days ago';
    } else if (diff.inDays == 3) {
      lastseen = 'Last active 3 days ago';
    } else if (diff.inDays == 4) {
      lastseen = 'Last active 4 days ago';
    } else if (diff.inDays == 5) {
      lastseen = 'Last active 5 days ago';
    } else if (diff.inDays == 6) {
      lastseen = 'Last active 6 days ago';
    } else if (diff.inDays > 6) {
      lastseen = dateFormatToEEEDDMMMYYYY(timeStamp: timeStamp);
    }
    return lastseen;
  }
}

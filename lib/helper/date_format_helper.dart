import 'package:intl/intl.dart';

class DateFormatFromTimeStamp {
  String dateFormatToEEEDDMMMYYYY({required String timeStamp}) =>
      DateFormat('EEE, dd MMM - yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)),
      );

  DateTime dateTime({required String timeStamp}) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));

  String dateFormatToEEEDDMMMYYYYatTime({required String timeStamp}) =>
      DateFormat('EEE, dd MMM - yyyy, hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)),
      );

  String dateFormatToDDMMMYYYYatTime({required String timeStamp}) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp)),
      );

  String dateFormatToDDMMYYYY({required DateTime dateTime}) =>
      DateFormat('dd/MM/yyyy').format(dateTime);

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

  String messageLastSeenFromTimeStamp(String timeStamp) {
    final DateTime messageDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(Duration(minutes: 1));
    DateTime localDateTime = messageDateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return 'Just Now';
    }

    String roughTimeString = DateFormat('jm').format(messageDateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday, $roughTimeString';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);
      return '$weekday, $roughTimeString';
    }

    return '${DateFormat('dd MMM yyyy').format(messageDateTime)}, $roughTimeString';
  }

  String chatListLastSeenFromTimeStamp(String timeStamp) {
    final DateTime messageDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(Duration(minutes: 1));
    DateTime localDateTime = messageDateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return 'Just Now';
    }

    String roughTimeString = DateFormat('jm').format(messageDateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Today';
    }

    DateTime yesterday = now.subtract(Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);
      return weekday;
    }

    return '${DateFormat('dd MMM yyyy').format(messageDateTime)}, $roughTimeString';
  }
}

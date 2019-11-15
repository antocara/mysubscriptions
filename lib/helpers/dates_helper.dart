import 'package:intl/intl.dart';

class DatesHelper {
  static DateTime toDateFromString(String stringDate) {
    var formatter = new DateFormat('dd MMM yyyy');
    final result = formatter.parse(stringDate);
    return result;
  }

  static String toStringFromDate(DateTime date) {
    if (date == null) return "";
    var formatter = new DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  static String toStringWithMonthAndYear(DateTime date) {
    if (date == null) return "";
    var formatter = new DateFormat('MMM yyyy');
    return formatter.format(date);
  }

  static String toStringWithYear(DateTime date) {
    if (date == null) return "";
    var formatter = new DateFormat('yyyy');
    return formatter.format(date);
  }

  static DateTime tomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  static DateTime afterTomorrow() {
    final tomorrow = DatesHelper.tomorrow();
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day + 1);
  }

  static DateTime today() {
    return DateTime.now();
  }

  static DateTime toDateFromEpoch(int epochValue) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(epochValue);
    var stringDate = toStringFromDate(date);
    final result = toDateFromString(stringDate);
    return result;
  }

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  static DateTime firstDayOfMonth(DateTime month) {
    return new DateTime(month.year, month.month);
  }

  static DateTime firstDayOfYear(DateTime month) {
    return new DateTime(month.year);
  }

  static bool belongThisYear(DateTime questionDate) {
    final currentMonth = DateTime.now().year;
    return currentMonth == questionDate.year;
  }

  static String parseNumberMonthToName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Ene';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Abr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Ago';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dic';
      default:
        return '';
    }
  }

  static bool isHourToDisplayNotification() {
    final thisHour = DateTime.now().hour;

    return (thisHour > 7 && thisHour < 9);
  }
}

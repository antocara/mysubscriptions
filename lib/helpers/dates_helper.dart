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
}

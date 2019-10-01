import 'package:intl/intl.dart';

class DatesHelper {
  static DateTime toDateFromString(String stringDate) {
    var formatter = new DateFormat('dd MMM yyyy');
    final result = formatter.parse(stringDate);
    return result;
  }

  static String toStringFromDate(DateTime date) {
    var formatter = new DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  static DateTime toDateFromEpoch(int epochValue) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(epochValue);
    var stringDate = toStringFromDate(date);
    final result = toDateFromString(stringDate);
    return result;
  }
}

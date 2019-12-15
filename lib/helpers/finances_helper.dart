import 'package:subscriptions/data/entities/renewal.dart';

class FinancesHelper {
  static double calculateAmountByMonth(List<Renewal> data, int month) {
    final fixMonthWithDecember = _fixMonthDecember(month);
    return data.where((renewal) {
      return renewal.renewalAt.month == fixMonthWithDecember;
    }).fold(0, (initialValue, renewal) {
      return initialValue + renewal.subscription.price;
    });
  }

  static int _fixMonthDecember(int month) {
    if (month == 13) {
      return 1;
    } else {
      return month;
    }
  }
}

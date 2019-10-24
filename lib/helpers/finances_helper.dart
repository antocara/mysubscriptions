import 'package:subscriptions/data/entities/renewal.dart';

class FinancesHelper {
  static double calculateAmountByMonth(List<Renewal> data, int month) {
    return data.where((renewal) {
      return renewal.renewalAt.month == month;
    }).fold(0, (initialValue, renewal) {
      return initialValue + renewal.subscription.price;
    });
  }
}

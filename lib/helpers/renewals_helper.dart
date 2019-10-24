import 'package:subscriptions/data/entities/renewal.dart';

class RenewalsHelper {
  static bool isRenewalOfCurrentMonth(int index, List<Renewal> data) {
    return (index > 0 && index < _countRenewalThisMonth(data) + 1);
  }

  static bool isRenewalOfNextMonth(int index, List<Renewal> data) {
    return index == _countRenewalThisMonth(data) + 1;
  }

  static int _countRenewalThisMonth(List<Renewal> data) {
    return data
        .where((renewal) {
          return _isAtThisMonth(renewal);
        })
        .toList()
        .length;
  }

  static bool _isAtThisMonth(Renewal renewal) {
    final currentMonth = DateTime.now().month;
    return currentMonth == renewal.renewalAt.month;
  }
}

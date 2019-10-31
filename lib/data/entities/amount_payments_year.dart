import 'package:subscriptions/data/entities/subscription.dart';

class AmountPaymentsYear {
  AmountPaymentsYear({this.subscriptionId, this.year, this.amount});

  int subscriptionId;
  Subscription subscription;
  String year;
  double amount;

  Map<String, dynamic> toMap() {
    return {'subscription_id': subscriptionId, 'year': year, 'amount': amount};
  }

  static AmountPaymentsYear fromMap(Map<String, dynamic> map) {
    return AmountPaymentsYear(
        subscriptionId: map['subscription_id'],
        year: map['year'],
        amount: map['amount']);
  }
}

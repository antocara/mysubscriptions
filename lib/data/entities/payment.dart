import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class Payment implements Comparable<Payment> {
  Payment(
      {this.id,
      this.renewal,
      this.subscription,
      this.insertAt,
      this.renewalAt});

  int id;
  Renewal renewal;
  Subscription subscription;
  DateTime insertAt;
  DateTime renewalAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'renewal_id': renewal.id,
      'subscription_id': subscription.id,
      'price': subscription.price,
      'renewal_at': renewalAtSince1970,
      'insert_at': insertAtSince1970,
    };
  }

  static Payment fromMap(Map<String, dynamic> map) {
    return Payment(
        id: map['id'],
        renewal: Renewal(id: map['renewal_id']),
        subscription:
            Subscription(id: map['subscription_id'], price: map['price']),
        insertAt: DatesHelper.toDateFromEpoch(map['insert_at']),
        renewalAt: DatesHelper.toDateFromEpoch(map['renewal_at']));
  }

  // Conversión de valores para guardarlos corectamente en
  // sqlite según los tipos que maneja

  int get insertAtSince1970 {
    return insertAt.millisecondsSinceEpoch ?? 0.00;
  }

  int get renewalAtSince1970 {
    return renewalAt.millisecondsSinceEpoch ?? 0.00;
  }

  String get renewalAtPretty {
    return DatesHelper.toStringFromDate(renewalAt);
  }

  @override
  int compareTo(Payment other) {
    return subscription.price < other.subscription.price ? 1 : 0;
  }
}

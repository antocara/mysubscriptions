import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class Renewal {
  Renewal({this.id, this.subscription, this.renewalAt});

  int id;
  Subscription subscription;
  DateTime renewalAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subscription_id': subscription.id,
      'renewal_at': nextRenewalAtSince1970,
    };
  }

  static Renewal fromMap(Map<String, dynamic> map) {
    return Renewal(
      id: map['id'],
      subscription: Subscription(id: map['subscription_id']),
      renewalAt: DatesHelper.toDateFromEpoch(map['renewal_at']),
    );
  }

  // Conversión de valores apra guardarlos corectamente en
  // sqlite según los tipos que maneja

  int get nextRenewalAtSince1970 {
    return renewalAt.millisecondsSinceEpoch ?? 0.00;
  }

  String get renewalAtPretty {
    return DatesHelper.toStringFromDate(renewalAt);
  }
}

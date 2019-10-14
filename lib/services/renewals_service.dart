import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/renewal_period.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class RenewalsService {
  static final maxRenewalDate = DateTime(2040, 1, 1);

  Future<List<Renewal>> createRenewalsForSubscription(
      Subscription subscription) async {
    final firstBill = subscription.firstBill;
    final renewal = subscription.renewal;
    final renewalPeriod = subscription.renewalPeriod;

    DateTime currentRenewal = firstBill;

    List<Renewal> renewals = [_createRenewal(subscription, firstBill)];

    while (currentRenewal.isBefore(maxRenewalDate)) {
      final nextRenewalDate =
          _getDurationInDaysFromRenewal(renewalPeriod, renewal, currentRenewal);
      renewals.add(_createRenewal(subscription, nextRenewalDate));
      currentRenewal = nextRenewalDate;
    }

    return Future.value(renewals);
  }

  Future<List<Renewal>> createRenewalsForSubscriptionBetween(
      {Subscription subscription, DateTime startDate, DateTime endDate}) async {
    final renewal = subscription.renewal;
    final renewalPeriod = subscription.renewalPeriod;

    DateTime currentRenewal = startDate;

    List<Renewal> renewals = [_createRenewal(subscription, startDate)];

    while (currentRenewal.isBefore(endDate)) {
      final nextRenewalDate =
          _getDurationInDaysFromRenewal(renewalPeriod, renewal, currentRenewal);
      renewals.add(_createRenewal(subscription, nextRenewalDate));
      currentRenewal = nextRenewalDate;
    }

    return Future.value(renewals);
  }

  DateTime _getDurationInDaysFromRenewal(RenewalPeriodValues renewalPeriod,
      int renewalValue, DateTime currentRenewal) {
    switch (renewalPeriod) {
      case RenewalPeriodValues.day:
        return new DateTime(currentRenewal.year, currentRenewal.month,
            currentRenewal.day + renewalValue);
      case RenewalPeriodValues.week:
        return new DateTime(currentRenewal.year, currentRenewal.month,
            currentRenewal.day + (7 * renewalValue));
      case RenewalPeriodValues.month:
        return new DateTime(currentRenewal.year,
            currentRenewal.month + renewalValue, currentRenewal.day);
      case RenewalPeriodValues.year:
        return new DateTime(currentRenewal.year + renewalValue,
            currentRenewal.month, currentRenewal.day);
    }
    return currentRenewal;
  }

  Renewal _createRenewal(Subscription subscription, DateTime nextRenewal) {
    return Renewal(subscription: subscription, renewalAt: nextRenewal);
  }
}

import 'package:subscriptions/data/database/daos/renewal_dao.dart';
import 'package:subscriptions/data/database/daos/subscription_dao.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class RenewalRepository {
  RenewalDao _renewalDao;
  SubscriptionDao _subscriptionDao;

  RenewalRepository(RenewalDao renewalDao, SubscriptionDao subscriptionDao) {
    _renewalDao = renewalDao;
    _subscriptionDao = subscriptionDao;
  }

  Future<List<Renewal>> fetchNextRenewalsForTwoMonths() async {
    final DateTime now = DateTime.now();
    final DateTime lastDayNextMonth =
        DatesHelper.lastDayOfMonth(DateTime(now.year, now.month + 1));
    final result = await _renewalDao.fetchRenewalBetween(
        starDate: now, endDate: lastDayNextMonth);

    final renewalWithSubscriptions = result.map((renewal) async {
      final subscription = await _subscriptionDao.fetchSubscription(
          subscription: renewal.subscription);
      renewal.subscription = subscription;
      return renewal;
    }).toList();
    return Future.wait(renewalWithSubscriptions);
  }

  Future<List<Renewal>> fetchAllRenewalsBySubscriptionUntil(
      Subscription subscription, DateTime until) async {
    final result =
        await _renewalDao.fetchAllRenewalBy(subscription: subscription);

    return result;
  }
}

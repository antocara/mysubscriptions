import 'package:flutter/cupertino.dart';
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

  void saveRenewal({@required Renewal renewal}) async {
    _renewalDao.insertRenewal(renewal: renewal);
  }

  Future<List<Renewal>> fetchNextRenewalsForTwoMonths() async {
    final DateTime now = DateTime.now();
    final DateTime lastDayNextMonth = DatesHelper.lastDayOfMonth(DateTime(now.year, now.month + 1));
    final result = await _renewalDao.fetchRenewalBetween(starDate: now, endDate: lastDayNextMonth);

    final renewalWithSubscriptions = result.map((renewal) async {
      final subscription =
          await _subscriptionDao.fetchActiveSubscription(subscription: renewal.subscription);
      renewal.subscription = subscription;
      return renewal;
    }).toList();
    return Future.wait(renewalWithSubscriptions);
  }

  Future<List<Renewal>> fetchAllRenewalsBySubscriptionUntil(
      Subscription subscription, DateTime until) async {
    final result = await _renewalDao.fetchAllRenewalBy(subscription: subscription);

    return result;
  }

  Future<List<Renewal>> fetchSubscriptionsRenewTomorrow() async {
    final DateTime today = DatesHelper.today();

    final DateTime afterTomorrow = DatesHelper.afterTomorrow();

    final result =
        await _renewalDao.fetchRenewalBetweenNotEquals(starDate: today, endDate: afterTomorrow);

    final renewalWithSubscriptions = result.map((renewal) async {
      final subscription =
          await _subscriptionDao.fetchActiveSubscription(subscription: renewal.subscription);
      renewal.subscription = subscription;
      return renewal;
    }).toList();
    return Future.wait(renewalWithSubscriptions);
  }

  ///
  /// Fetch a renewals list between two Dates
  ///
  Future<List<Renewal>> fetchRenewalsBetween(DateTime startDate, DateTime endDate) async {
    final result = await _renewalDao.fetchRenewalBetween(starDate: startDate, endDate: endDate);

    final renewalWithSubscriptions = result.map((renewal) async {
      renewal.subscription = await _fetchSubcriptionData(renewal);
      return renewal;
    }).toList();
    return Future.wait(renewalWithSubscriptions);
  }

  ///Utils

  Future<Subscription> _fetchSubcriptionData(Renewal renewal) async {
    return await _subscriptionDao.fetchActiveSubscription(subscription: renewal.subscription);
  }
}

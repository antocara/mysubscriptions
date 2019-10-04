import 'package:subscriptions/data/database/daos/renewal_dao.dart';
import 'package:subscriptions/data/database/daos/subscription_dao.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/services/renewals_service.dart';

class SubscriptionRepository {
  SubscriptionDao _subscriptionDao;
  RenewalDao _renewalDao;

  SubscriptionRepository(
      SubscriptionDao subscriptionDao, RenewalDao renewalDao) {
    _subscriptionDao = subscriptionDao;
    _renewalDao = renewalDao;
  }

  Future<bool> saveSubscription(Subscription subscription) async {
    final subscriptionId =
        await _subscriptionDao.insertSubscription(subscription);

    subscription.id = subscriptionId;
    final renewalsList =
        await RenewalsService().createRenewalsForSubscription(subscription);
    renewalsList.forEach((renewal) {
      _renewalDao.insertRenewal(renewal);
    });
    return Future.value(true);
  }

  Future<List<Subscription>> fetchAllSubscriptionsUntil(DateTime until) async {
    final result = await _subscriptionDao.fetchAllSubscriptionsUntil(
        untilAt: DateTime(2019, 10));
  }
}

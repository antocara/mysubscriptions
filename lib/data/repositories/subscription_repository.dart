import 'package:subscriptions/data/database/subscription_dao.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class SubscriptionRepository {
  var _subscriptionDao;

  SubscriptionRepository(SubscriptionDao subscriptionDao) {
    this._subscriptionDao = subscriptionDao;
  }

  Future<bool> saveSubscription(Subscription subscription) {
    return _subscriptionDao.insertSubscription(subscription);
  }

  Future<List<Subscription>> fetchAllSubscriptionsUntil(DateTime until) async {
    final result = await _subscriptionDao.fetchAllSubscriptionsUntil(
        untilAt: DateTime(2019, 10));
  }
}

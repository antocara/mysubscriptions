import 'package:subscriptions/data/database/renewal_dao.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class RenewalRepository {
  RenewalDao _renewalDao;

  RenewalRepository(RenewalDao renewalDao) {
    _renewalDao = renewalDao;
  }

  Future<List<Renewal>> fetchAllRenewalsBySubscriptionUntil(
      Subscription subscription, DateTime until) async {
    final result =
        await _renewalDao.fetchAllRenewalBy(subscription: subscription);

    return result;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:subscriptions/data/database/daos/renewal_dao.dart';
import 'package:subscriptions/data/database/daos/subscription_dao.dart';

import 'package:subscriptions/data/entities/subscription.dart';

class SubscriptionRepository {
  SubscriptionDao _subscriptionDao;
  RenewalDao _renewalDao;

  SubscriptionRepository(
      {@required SubscriptionDao subscriptionDao, @required RenewalDao renewalDao}) {
    _subscriptionDao = subscriptionDao;
    _renewalDao = renewalDao;
  }

  ///Guarda una subscripción en base de datos y genera todas las futuras
  /// renovaciones para esta suscripción
  Future<Subscription> saveSubscription({Subscription subscription}) async {
    final subscriptionId = await _subscriptionDao.insertSubscription(subscription: subscription);

    subscription.id = subscriptionId;
    return Future.value(subscription);
  }

  ///Obtiene todas las suscripciones guardadas en base de datos
  Future<List<Subscription>> fetchAllSubscriptions() async {
    return await _subscriptionDao.fetchAllSubscriptions();
  }

  /// Delete subscriptions and following renewals of this subscription
  /// The subscriptions deletion are done at logical level
  Future<bool> deleteSubscription({@required Subscription subscription}) async {
    final deleteResult = await _subscriptionDao.deleteSubscription(subscription: subscription);

    bool deleteRenewalsResult;
    if (deleteResult) {
      deleteRenewalsResult =
          await _renewalDao.deleteAllRenewalsFromToday(subscription: subscription);
    } else {
      return false;
    }

    return deleteRenewalsResult;
  }
}

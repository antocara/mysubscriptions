import 'package:flutter/cupertino.dart';
import 'package:subscriptions/data/database/daos/renewal_dao.dart';
import 'package:subscriptions/data/database/daos/subscription_dao.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/services/renewals_service.dart';

class SubscriptionRepository {
  SubscriptionDao _subscriptionDao;
  RenewalDao _renewalDao;
  RenewalsService _renewalsService;

  SubscriptionRepository(SubscriptionDao subscriptionDao, RenewalDao renewalDao,
      RenewalsService renewalsService) {
    _subscriptionDao = subscriptionDao;
    _renewalDao = renewalDao;
    _renewalsService = renewalsService;
  }

  ///Guarda una subscripción en base de datos y genera todas las futuras
  /// renovaciones para esta suscripción
  Future<bool> saveSubscription({Subscription subscription}) async {
    final subscriptionId =
        await _subscriptionDao.insertSubscription(subscription: subscription);

    subscription.id = subscriptionId;
    final renewalsList =
        await _renewalsService.createRenewalsForSubscription(subscription);
    renewalsList.forEach((renewal) {
      _renewalDao.insertRenewal(renewal: renewal);
    });
    PaymentInject.buildPaymentServices().updatePaymentData();
    return Future.value(true);
  }

  ///Obtiene todas las suscripciones guardadas en base de datos
  Future<List<Subscription>> fetchAllSubscriptions() async {
    return await _subscriptionDao.fetchAllSubscriptions();
  }

  /// Delete subscriptions and following renewals of this subscription
  /// The subscriptions deletion are done at logical level
  Future<bool> deleteSubscription({@required Subscription subscription}) async {
    final deleteResult =
        await _subscriptionDao.deleteSubscription(subscription: subscription);

    bool deleteRenewalsResult;
    if (deleteResult) {
      deleteRenewalsResult = await _renewalDao.deleteAllRenewalsFromToday(
          subscription: subscription);
    } else {
      return false;
    }

    return deleteRenewalsResult;
  }
}

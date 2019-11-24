import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/di/subscription_inject.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';
import 'package:subscriptions/data/repositories/subscription_repository.dart';
import 'package:subscriptions/services/renewals_service.dart';

class AddSubscriptionBloc {
  SubscriptionRepository _subscriptionRepository;
  RenewalsService _renewalsService;
  RenewalRepository _renewalRepository;

  AddSubscriptionBloc() {
    _subscriptionRepository = SubscriptionInject.buildSubscriptionRepository();
    _renewalsService = RenewalsService();
    _renewalRepository = RenewalInject.buildRenewalRepository();
  }

  StreamController _streamController = StreamController<Subscription>.broadcast();

  Stream<Subscription> get addSubscriptionStream => _streamController.stream;

  void addSubscription({@required Subscription subscription}) async {
    final subscriptionSaved = await _subscriptionRepository.saveSubscription(
        subscription: subscription);

    _createRenewalForSubscription(subscription: subscriptionSaved);

    _createPaymentForSubscription();

    _streamController.add(subscription);
  }

  void _createRenewalForSubscription({@required Subscription subscription}) async {
    final renewalsList =
        await _renewalsService.createRenewalsForSubscription(subscription);

    renewalsList.forEach((renewal) {
      _renewalRepository.saveRenewal(renewal: renewal);
    });
  }

  void _createPaymentForSubscription() {
    PaymentInject.buildPaymentServices().updatePaymentData();
  }

  void disposed() {
    _streamController.close();
  }
}

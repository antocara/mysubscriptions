import 'dart:async';

import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/di/subscription_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/data/repositories/subscription_repository.dart';

class DetailRenewalBloc {
  DetailRenewalBloc() {
    _paymentRepository = PaymentInject.buildPaymentRepository();
    _subscriptionRepository = SubscriptionInject.buildSubscriptionRepository();
  }

  PaymentRepository _paymentRepository;
  SubscriptionRepository _subscriptionRepository;

  StreamController _streamController =
      StreamController<List<Payment>>.broadcast();

  Stream<List<Payment>> get paymentsBySubscriptions => _streamController.stream;

  void fetchUpcomingRenewals({Subscription subscription}) async {
    final payments =
        await _paymentRepository.fetchPaymentsBySubscription(subscription);
    _streamController.add(payments);
  }

  Future<bool> deleteSubscription({Subscription subscription}) async {
    return await _subscriptionRepository.deleteSubscription(
        subscription: subscription);
  }

  void disposed() {
    _streamController.close();
  }
}

import 'dart:async';

import 'package:subscriptions/data/di/payment_inject.dart';

import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';

class DetailRenewalBloc {
  DetailRenewalBloc() {
    _paymentRepository = PaymentInject.buildPaymentRepository();
  }

  PaymentRepository _paymentRepository;

  StreamController _streamController =
      StreamController<List<Payment>>.broadcast();

  Stream<List<Payment>> get paymentsBySubscriptions => _streamController.stream;

  void fetchUpcomingRenewals({Subscription subscription}) async {
    final payments =
        await _paymentRepository.fetchPaymentsBySubscription(subscription);
    _streamController.add(payments);
  }

  void disposed() {
    _streamController.close();
  }
}

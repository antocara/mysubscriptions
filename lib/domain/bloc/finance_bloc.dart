import 'dart:async';

import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class FinanceBloc {
  FinanceBloc() {
    _paymentRepository = PaymentInject.buildPaymentRepository();
  }

  PaymentRepository _paymentRepository;

  StreamController _streamController =
      StreamController<List<Payment>>.broadcast();

  Stream<List<Payment>> get paymentsThisMonth => _streamController.stream;

  void fetchRenewalsThisMonth() async {
    final DateTime now = DateTime.now();
    final firstDateThisMonth = DatesHelper.firstDayOfMonth(DateTime.now());
    final DateTime lastDayMonth =
        DatesHelper.lastDayOfMonth(DateTime(now.year, now.month));

    final result = await _paymentRepository.fetchAllRenewalsByMonth(
        firstDateThisMonth, lastDayMonth);
    result.sort((first, second) {
      return second.subscription.price.compareTo(first.subscription.price);
    });

    _streamController.add(result);
  }

  void disposed() {
    _streamController.close();
  }
}

import 'dart:async';

import 'package:subscriptions/data/database/daos/payment_dao.dart';
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

  StreamController _paymentsThisMonthStream =
      StreamController<List<Payment>>.broadcast();
  StreamController _paymentsUntilTodayStream =
      StreamController<List<Payment>>.broadcast();

  Stream<List<Payment>> get paymentsThisMonth =>
      _paymentsThisMonthStream.stream;
  Stream<List<Payment>> get paymentsUntilToday =>
      _paymentsUntilTodayStream.stream;

  void fetchRenewalsThisMonth() async {
    final DateTime now = DateTime.now();
    final firstDateThisMonth = DatesHelper.firstDayOfMonth(DateTime.now());
    final DateTime lastDayMonth =
        DatesHelper.lastDayOfMonth(DateTime(now.year, now.month));

    final result = await _paymentRepository.fetchAllRenewalsByMonth(
        firstDateThisMonth, lastDayMonth, SortBy.ASC);

    result.sort((first, second) {
      return second.subscription.price.compareTo(first.subscription.price);
    });

    _paymentsThisMonthStream.add(result);
  }

  void fetchRenewalsUntilToday() async {
    final DateTime now = DateTime.now();
    final firstDateYear = DatesHelper.firstDayOfYear(DateTime.now());

    final result = await _paymentRepository.fetchAllRenewalsByMonth(
        firstDateYear, now, SortBy.DESC);

    result.sort((first, second) {
      return second.subscription.price.compareTo(first.subscription.price);
    });

    _paymentsUntilTodayStream.add(result);
  }

  void disposed() {
    _paymentsThisMonthStream.close();
    _paymentsUntilTodayStream.close();
  }
}

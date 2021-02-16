import 'dart:async';

import 'package:subscriptions/data/database/daos/payment_dao.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/amount_payments_year.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class FinanceBloc {
  FinanceBloc() {
    _paymentRepository = PaymentInject.buildPaymentRepository();
  }

  late PaymentRepository _paymentRepository;

  StreamController _paymentsThisMonthStream =
      StreamController<List<Payment>>.broadcast();
  StreamController _paymentsUntilTodayStream =
      StreamController<List<Payment>>.broadcast();
  StreamController _paymentsTotalStream =
      StreamController<List<AmountPaymentsYear>>.broadcast();

  Stream<List<Payment>> get paymentsThisMonth =>
      _paymentsThisMonthStream.stream as Stream<List<Payment>>;

  Stream<List<Payment>> get paymentsUntilToday =>
      _paymentsUntilTodayStream.stream as Stream<List<Payment>>;

  Stream<List<AmountPaymentsYear>> get paymentsTotal =>
      _paymentsTotalStream.stream as Stream<List<AmountPaymentsYear>>;

  void fetchRenewalsThisMonth() async {
    final DateTime now = DateTime.now();
    final firstDateThisMonth = DatesHelper.firstDayOfMonth(DateTime.now());
    final DateTime lastDayMonth =
        DatesHelper.lastDayOfMonth(DateTime(now.year, now.month));

    List<Payment> result = await _paymentRepository.fetchAllRenewalsByMonth(
        firstDateThisMonth, lastDayMonth, SortBy.ASC);

    if (result.length > 0) {
      result.sort((first, second) {
        return second.subscription.price.compareTo(first.subscription.price);
      });
    }

    _paymentsThisMonthStream.add(result);
  }

  void fetchRenewalsUntilToday() async {
    final DateTime now = DateTime.now();
    final firstDateYear = DatesHelper.firstDayOfYear(DateTime.now());

    var result = await _paymentRepository.fetchAllRenewalsByMonth(
        firstDateYear, now, SortBy.DESC);

    if (result.length > 0) {
      result.sort((first, second) {
        return second.subscription.price.compareTo(first.subscription.price);
      });
    }

    _paymentsUntilTodayStream.add(result);
  }

  void fetchTotalRenewals() async {
    final result = await _paymentRepository.fetchAllPaymentsByYears();

    var flattened = result.expand((pair) => pair).toList();
    _paymentsTotalStream.add(flattened);
  }

  void disposed() {
    _paymentsThisMonthStream.close();
    _paymentsUntilTodayStream.close();
    _paymentsTotalStream.close();
  }
}

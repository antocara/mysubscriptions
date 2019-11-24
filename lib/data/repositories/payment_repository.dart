import 'package:subscriptions/data/database/daos/payment_dao.dart';
import 'package:subscriptions/data/database/daos/subscription_dao.dart';
import 'package:subscriptions/data/entities/amount_payments_year.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class PaymentRepository {
  PaymentDao _paymentDao;
  SubscriptionDao _subscriptionDao;

  PaymentRepository(PaymentDao paymentDao, SubscriptionDao subscriptionDao) {
    _paymentDao = paymentDao;
    _subscriptionDao = subscriptionDao;
  }

  Future<bool> savePayment(Payment payment) async {
    await _paymentDao.insertPayment(payment: payment);
    return Future.value(true);
  }

  Future<List<Payment>> fetchPaymentsBySubscription(
      Subscription subscription) async {
    final result = await _paymentDao.fetchPaymentsBySubscriptions(
        subscription: subscription);
    return Future.value(result);
  }

  Future<Payment> fetchLastPaymentBySubscription(
      Subscription subscription) async {
    final result = await _paymentDao.fetchLastPaymentBySubscriptions(
        subscription: subscription);
    return Future.value(result);
  }

  Future<List<Payment>> fetchAllRenewalsByMonth(
      DateTime startDate, DateTime endDate, SortBy sortBy) async {
    final result = await _paymentDao.fetchPaymentsBetween(
        starDate: startDate, endDate: endDate, sortBy: sortBy);

    final paymentsWithSubscriptions = result.map((payment) async {
      final subscription = await _subscriptionDao.fetchSubscription(
          subscription: payment.subscription);

      payment.subscription = subscription;
      return payment;
    }).toList();

    return Future.wait(paymentsWithSubscriptions);
  }

  Future<List<List<AmountPaymentsYear>>> fetchAllPaymentsByYears() async {
    final List<List<AmountPaymentsYear>> result =
        await _paymentDao.fetchAllPaymentsGroupedByYears();

    final a = result.map((listAmountPayments) async {
      return await _fetchSubscriptionsByPayment(listAmountPayments);
    });

    return Future.wait(a);
  }

  // recupera de DB los datos de una suscripción y la añade al objeto
  // AmountPaymentYear
  Future<List<AmountPaymentsYear>> _fetchSubscriptionsByPayment(
      List<AmountPaymentsYear> data) async {
    final paymentsWithSubscriptions = data.map((amountPayment) async {
      final subscriptionWithId = Subscription(id: amountPayment.subscriptionId);
      final subscriptionData = await _subscriptionDao.fetchSubscription(
          subscription: subscriptionWithId);
      amountPayment.subscription = subscriptionData;
      return amountPayment;
    });

    return Future.wait(paymentsWithSubscriptions);
  }
}

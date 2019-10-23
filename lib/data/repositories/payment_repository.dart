import 'package:subscriptions/data/database/daos/payment_dao.dart';
import 'package:subscriptions/data/database/daos/subscription_dao.dart';
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
    await _paymentDao.insertPayment(payment);
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
      DateTime startDate, endDate) async {
    final result = await _paymentDao.fetchPaymentsBetween(
        starDate: startDate, endDate: endDate);

    final paymentsWithSubscriptions = result.map((payment) async {
      final subscription = await _subscriptionDao.fetchSubscription(
          subscription: payment.subscription);

      payment.subscription = subscription;
      return payment;
    }).toList();

    return Future.wait(paymentsWithSubscriptions);
  }

  Future<List<Payment>> fetchAllRenewals() async {
    final result = await _paymentDao.fetchAllPayments();

    final paymentsWithSubscriptions = result.map((payment) async {
      final subscription = await _subscriptionDao.fetchSubscription(
          subscription: payment.subscription);

      payment.subscription = subscription;
      return payment;
    }).toList();

    return Future.wait(paymentsWithSubscriptions);
  }
}

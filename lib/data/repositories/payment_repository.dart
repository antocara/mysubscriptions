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

//  Future<List<Renewal>> fetchAllRenewalsBySubscriptionUntil(
//      Subscription subscription, DateTime until) async {
//    final result =
//    await _renewalDao.fetchAllRenewalBy(subscription: subscription);
//
//    return result;
//  }
}

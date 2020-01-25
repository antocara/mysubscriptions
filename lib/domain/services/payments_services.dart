import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/renewal.dart';

import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';
import 'package:subscriptions/data/repositories/subscription_repository.dart';

import 'package:subscriptions/helpers/dates_helper.dart';

class PaymentServices {
  SubscriptionRepository _subscriptionRepository;
  PaymentRepository _paymentRepository;
  RenewalRepository _renewalRepository;

  PaymentServices(SubscriptionRepository subscriptionRepository,
      PaymentRepository paymentRepository, RenewalRepository renewalRepository) {
    _subscriptionRepository = subscriptionRepository;
    _paymentRepository = paymentRepository;
    _renewalRepository = renewalRepository;
  }

  void updatePaymentData() async {
    //fetch subscripciones disponibles
    final subscriptions = await _subscriptionRepository.fetchAllSubscriptions();
    //para cada subscripcion buscar en tabla último pago anotado.
    subscriptions.forEach((subscription) async {
      final lastPayment = await _paymentRepository.fetchLastPaymentBySubscription(subscription);
      lastPayment.subscription = subscription;

      //recupero las renovaciones desde la última pagada hasta hoy
      final today = DatesHelper.todayOnlyDate();
      if (lastPayment.renewalAt == null) {
        final nextRenewals = await _renewalRepository.fetchRenewalsBetween(
            lastPayment.subscription.firstBill, today);
        _savePayments(nextRenewals);
      } else {
        final nextRenewals =
            await _renewalRepository.fetchRenewalsBetween(lastPayment.renewalAt, today);
        _savePayments(nextRenewals);
      }
    });
  }

  void _savePayments(List<Renewal> futureRenewals) {
    futureRenewals.forEach((renewal) {
      final payment = Payment();
      payment.renewal = renewal;
      payment.subscription = renewal.subscription;
      payment.insertAt = DateTime.now();
      payment.renewalAt = renewal.renewalAt;
      _paymentRepository.savePayment(payment);
    });
  }
  
}

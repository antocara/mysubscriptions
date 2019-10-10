import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/data/repositories/subscription_repository.dart';
import 'package:subscriptions/services/renewals_service.dart';

class PaymentServices {
  SubscriptionRepository _subscriptionRepository;
  PaymentRepository _paymentRepository;
  RenewalsService _renewalsService;

  PaymentServices(SubscriptionRepository subscriptionRepository,
      PaymentRepository paymentRepository, RenewalsService renewalsService) {
    _subscriptionRepository = subscriptionRepository;
    _paymentRepository = paymentRepository;
    _renewalsService = renewalsService;
  }

  void updatePaymentData() async {
    //fetch subscripciones disponibles
    final subscriptions = await _subscriptionRepository.fetchAllSubscriptions();
    //para cada subscripcion buscar en tabla último pago anotado.
    subscriptions.forEach((subscription) async {
      final lastPayment =
          await _paymentRepository.fetchLastPaymentBySubscription(subscription);
      lastPayment.subscription = subscription;
      //calcular días de pago desde ese último día hasta la actualidad
      final futureRenewals = await _calculateRenewalsDatesFrom(lastPayment);
      _savePayments(futureRenewals);
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

  Future<List<Renewal>> _calculateRenewalsDatesFrom(Payment payment) async {
    if (payment.insertAt == null) {
      //no hay pagos guardados, hay que crear pagos desde la primera fecha hasta hoy
      return await _renewalsService.createRenewalsForSubscriptionBetween(
          subscription: payment.subscription,
          startDate: payment.subscription.firstBill,
          endDate: DateTime.now());
    } else if (payment.renewalAt.isBefore(DateTime.now())) {
      //existe algún pago guardado
      return await _renewalsService.createRenewalsForSubscriptionBetween(
          subscription: payment.subscription,
          startDate: payment.insertAt,
          endDate: DateTime.now());
    } else {
      return Future.value([]);
    }
  }
}

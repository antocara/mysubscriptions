import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';
import 'package:subscriptions/data/repositories/subscription_repository.dart';
import 'package:subscriptions/domain/services/renewals_service.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class PaymentServices {
  SubscriptionRepository _subscriptionRepository;
  PaymentRepository _paymentRepository;
  RenewalRepository _renewalRepository;

  PaymentServices(
      SubscriptionRepository subscriptionRepository,
      PaymentRepository paymentRepository,
      RenewalRepository renewalRepository) {
    _subscriptionRepository = subscriptionRepository;
    _paymentRepository = paymentRepository;
    _renewalRepository = renewalRepository;
  }

  void updatePaymentData() async {
    //fetch subscripciones disponibles
    final subscriptions = await _subscriptionRepository.fetchAllSubscriptions();
    //para cada subscripcion buscar en tabla último pago anotado.
    subscriptions.forEach((subscription) async {
      final lastPayment =
          await _paymentRepository.fetchLastPaymentBySubscription(subscription);
      lastPayment.subscription = subscription;

      //recupero las renovaciones desde la última pagada hasta hoy
      final today = DatesHelper.todayOnlyDate();
      if (lastPayment.renewalAt == null) {
        final nextRenewals = await _renewalRepository.fetchRenewalsBetween(
            lastPayment.subscription.firstBill, today);
        _savePayments(nextRenewals);
      } else {
        final nextRenewals = await _renewalRepository.fetchRenewalsBetween(
            lastPayment.renewalAt, today);
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

//  Future<List<Renewal>> calculateRenewalsDatesFrom(Payment payment) async {
//    if (payment.insertAt == null) {
//      //no hay pagos guardados, hay que crear pagos desde la primera fecha hasta hoy
//      return await _createRenewalsForPaymentsBetween(
//          subscription: payment.subscription,
//          startDate: payment.subscription.firstBill,
//          endDate: DatesHelper.todayOnlyDate());
//    } else if (payment.renewalAt.isBefore(DateTime.now())) {
//      //existe algún pago guardado
//      return await _createRenewalsForPaymentsBetween(
//          subscription: payment.subscription,
//          startDate: payment.insertAt,
//          endDate: DateTime.now());
//    } else {
//      return Future.value([]);
//    }
//  }
//
//  Future<List<Renewal>> _createRenewalsForPaymentsBetween(
//      {Subscription subscription, DateTime startDate, DateTime endDate}) async {
//    final renewal = subscription.renewal;
//    final renewalPeriod = subscription.renewalPeriod;
//
//    List<Renewal> renewals = [
//      RenewalsService.createRenewal(subscription, startDate)
//    ];
//    DateTime currentRenewal = RenewalsService.getDurationInDaysFromRenewal(
//        renewalPeriod, renewal, startDate);
//
//    while (currentRenewal.isBefore(endDate)) {
//      final nextRenewalDate = RenewalsService.getDurationInDaysFromRenewal(
//          renewalPeriod, renewal, currentRenewal);
//      renewals
//          .add(RenewalsService.createRenewal(subscription, nextRenewalDate));
//      currentRenewal = nextRenewalDate;
//    }
//
//    return Future.value(renewals);
//  }
}

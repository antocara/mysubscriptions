import 'package:subscriptions/data/database/daos/payment_dao.dart';
import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/di/subscription_inject.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/domain/services/payments_services.dart';

class PaymentInject {
  static PaymentServices buildPaymentServices() {
    return PaymentServices(SubscriptionInject.buildSubscriptionRepository(),
        buildPaymentRepository(), RenewalInject.buildRenewalService());
  }

  static PaymentRepository buildPaymentRepository() {
    return PaymentRepository(
        buildPaymentDao(), SubscriptionInject.buildSubscriptionDao());
  }

  static PaymentDao buildPaymentDao() {
    return PaymentDao(DatabaseProvider.instance.database);
  }
}

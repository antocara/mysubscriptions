import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/database/daos/renewal_dao.dart';
import 'package:subscriptions/data/di/subscription_inject.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';
import 'package:subscriptions/domain/services/renewals_service.dart';

class RenewalInject {
  static RenewalRepository buildRenewalRepository() {
    return RenewalRepository(
        buildRenewalDao(), SubscriptionInject.buildSubscriptionDao());
  }

  static RenewalDao buildRenewalDao() {
    return RenewalDao(database: DatabaseProvider.instance.database);
  }

  static RenewalsService buildRenewalService() {
    return RenewalsService();
  }
}

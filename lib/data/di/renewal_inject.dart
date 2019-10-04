import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/database/renewal_dao.dart';
import 'package:subscriptions/data/di/subscription_inject.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';

class RenewalInject {
  static RenewalRepository buildRenewalRepository() {
    return RenewalRepository(
        buildRenewalDao(), SubscriptionInject.buildSubscriptionDao());
  }

  static RenewalDao buildRenewalDao() {
    return RenewalDao(DatabaseProvider.instance.database);
  }
}

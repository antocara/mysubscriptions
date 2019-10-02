import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/database/subscription_dao.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/repositories/subscription_repository.dart';

class SubscriptionInject {
  static SubscriptionRepository buildSubscriptionRepository() {
    return SubscriptionRepository(
        buildSubscriptionDao(), RenewalInject.buildRenewalDao());
  }

  static SubscriptionDao buildSubscriptionDao() {
    return SubscriptionDao(DatabaseProvider.instance.database);
  }
}

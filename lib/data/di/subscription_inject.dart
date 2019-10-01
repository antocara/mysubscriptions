import 'package:subscriptions/data/database/database_provider.dart';
import 'package:subscriptions/data/database/subscription_dao.dart';

class SubscriptionInject {
  static SubscriptionDao buildSubscriptionDao() {
    return SubscriptionDao(DatabaseProvider.instance.database);
  }
}

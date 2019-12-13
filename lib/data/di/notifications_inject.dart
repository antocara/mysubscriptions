import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/domain/services/display_renew_notifications_services.dart';
import 'package:subscriptions/domain/services/local_notifications_services.dart';

class NotificationsInject {
  static DisplayRenewNotificationsServices buildNotificationsServices() {
    return DisplayRenewNotificationsServices(
        RenewalInject.buildRenewalRepository(), LocalNotificationsService());
  }
}

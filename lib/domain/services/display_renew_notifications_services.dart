import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';
import 'package:subscriptions/domain/services/local_notifications_services.dart';


class DisplayRenewNotificationsServices {
  DisplayRenewNotificationsServices(RenewalRepository renewalRepository,
      LocalNotificationsService localNotifications) {
    _renewalRepository = renewalRepository;
    _localNotifications = localNotifications;
  }

  RenewalRepository _renewalRepository;
  LocalNotificationsService _localNotifications;

  void displayRenewsNotifications() {
    _fetchRenewalsAfterTomorrow();
  }

  void _fetchRenewalsAfterTomorrow() async {
    final renewals = await _renewalRepository.fetchSubscriptionsRenewTomorrow();
    _showNotification(renewals);
  }

  String _buildNotificationTitle(List<Renewal> renewals) {
    //return AppLocalizations.of(context).translate("notification_title");
    return "Atención, tienes subscripciones a punto de renovarse";
  }

  String _buildNotificationMessage(List<Renewal> renewals) {
    final subscriptionsName = renewals
        .map((renewal) {
          return renewal.subscription.name;
        })
        .toList()
        .join(", ");
    return "Tus susbcripciones: $subscriptionsName, serán renovadas mañana. Revísalas por si deseas darte de baja de alguna.";
  }

  void _showNotification(List<Renewal> renewals) {
    final title = _buildNotificationTitle(renewals);
    final message = _buildNotificationMessage(renewals);
    _localNotifications.scheduleNotification(title, message);
  }
}

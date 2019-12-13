import 'package:subscriptions/data/di/notifications_inject.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:workmanager/workmanager.dart';

// método que se llama con cada jobs periódico
// que se ha registrado en el Workmanager
void _callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    BackgroundJobsServices.handleNotifications();
    return Future.value(true);
  });
}

class BackgroundJobsServices {
  static const TASK_TAG = "background_jobs_services";
  static const TASK_NAME = "periodic_tag";

  BackgroundJobsServices() {
    Workmanager.initialize(
        _callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
  }

  // Jobs que se ejecuta cada hora
  void registerPeriodicJobs() {
    Workmanager.registerPeriodicTask(
      TASK_TAG,
      TASK_NAME,
      frequency: Duration(minutes: 59),
    );
  }

  void cancelJobs() {
    Workmanager.cancelAll();
  }

  static void handleNotifications() {
    if (DatesHelper.isHourToDisplayNotification()) {
      NotificationsInject.buildNotificationsServices()
          .displayRenewsNotifications();
    }
  }
}

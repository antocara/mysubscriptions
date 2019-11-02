import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:subscriptions/presentations/navigation_manager.dart';

class LocalNotificationsService {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  LocalNotificationsService() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<void> _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    print("onDidReceiveLocalNotification");
  }

  Future<void> _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 30));
//    var vibrationPattern = Int64List(4);
//    vibrationPattern[0] = 0;
//    vibrationPattern[1] = 1000;
//    vibrationPattern[2] = 5000;
//    vibrationPattern[3] = 2000;

//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'your other channel id',
//        'your other channel name',
//        'your other channel description',
//        icon: 'secondary_icon',
//        sound: 'slow_spring_board',
//        largeIcon: 'sample_large_icon',
//        largeIconBitmapSource: BitmapSource.Drawable,
//        //vibrationPattern: vibrationPattern,
//        enableLights: true,
//        color: const Color.fromARGB(255, 255, 0, 0),
//        ledColor: const Color.fromARGB(255, 255, 0, 0),
//        ledOnMs: 1000,
//        ledOffMs: 500);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body  ad a da,sdn .adn a',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TankerNotificationService {
  static final TankerNotificationService _TankerNotificationService =
      TankerNotificationService._internal();

  factory TankerNotificationService() {
    return _TankerNotificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TankerNotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    var androidDetail = new AndroidNotificationDetails(
      'main_channel',
      'SAMSS',
      importance: Importance.high,
      playSound: false,
    );
    var iOSDetail = new IOSNotificationDetails();
    var generalNotification =
        new NotificationDetails(android: androidDetail, iOS: iOSDetail);
    await flutterLocalNotificationsPlugin.show(
        0, "Order Status", "Your order is pending.", generalNotification);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

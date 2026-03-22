import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> initTimezone() async {
    tz.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  }

  Future<bool> requestNotificationPermission() async {
    final androidImplementation =
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();

    final enabled = await androidImplementation?.areNotificationsEnabled();

    return enabled ?? false;
  }

  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }

  Future<void> showInstantNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'bloomind_channel',
      'Bloomind Notifications',
      channelDescription: 'Canal de notificaciones de Bloomind',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Bloomind',
      'Esta es una notificación de prueba',
      details,
    );
  }

  Future<void> scheduleNotificationInSeconds() async {
    const androidDetails = AndroidNotificationDetails(
      'bloomind_channel',
      'Bloomind Notifications',
      channelDescription: 'Canal de notificaciones de Bloomind',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Bloomind',
      'Recordatorio en 5 segundos',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
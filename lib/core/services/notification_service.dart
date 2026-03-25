import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/foundation.dart';
import 'package:bloomind/features/activities/model/activity.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/material.dart';



class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  TimeOfDay parseHour(String hourString) {
    try {
      final cleaned = hourString.trim().toUpperCase();

      final regex = RegExp(r'^(\d{1,2}):(\d{2})\s?(AM|PM)$');
      final match = regex.firstMatch(cleaned);

      if (match == null) {
        throw FormatException('Formato no válido: $hourString');
      }

      int hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final period = match.group(3)!;

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      print('Error parseando hora: $hourString');
      return const TimeOfDay(hour: 8, minute: 0);
    }
  }

  Future<void> scheduleActivitiesNotifications({
    required List<Activity> activities,
    required int minutesBefore,
  }) async {
    int notificationId = 200;

    for (final activity in activities) {
      if (activity.hour.isEmpty) continue;

      final time = parseHour(activity.hour);

      final now = tz.TZDateTime.now(tz.local);

      tz.TZDateTime activityDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // restar minutos antes
      final scheduledDate =
      activityDate.subtract(Duration(minutes: minutesBefore));

      if (scheduledDate.isBefore(now)) continue;

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: notificationId++,
        title: 'Actividad próxima',
        body: '${activity.emoji} ${activity.name} en $minutesBefore minutos',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'activity_channel',
            'Actividades del día',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );

      print("✅ Notificación programada: ${activity.name} → $scheduledDate");
    }
  }

  Future<void> cancelActivityNotifications() async {
    try {
      for (int i = 200; i < 300; i++) {
        await flutterLocalNotificationsPlugin.cancel(id: i);
      }
    } catch (e, st) {
      debugPrint('Error cancelando notificaciones de actividades: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> scheduleExactTestNotification({
    required int minutesFromNow,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Pruebas de notificación',
      channelDescription: 'Canal para pruebas exactas',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    final scheduledDate =
    tz.TZDateTime.now(tz.local).add(Duration(minutes: minutesFromNow));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 999,
      title: 'Bloomind',
      body: 'Prueba exacta programada',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleDebugNotificationInOneMinute() async {
    const androidDetails = AndroidNotificationDetails(
      'debug_channel',
      'Debug notifications',
      channelDescription: 'Canal de prueba para aislar errores',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(minutes: 1));

    debugPrint('🕒 NOW: $now');
    debugPrint('⏰ SCHEDULED: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 777,
      title: 'Bloomind Debug',
      body: 'Esta notificación debe aparecer en 1 minuto',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    debugPrint('📌 Pendientes después de programar: ${pending.length}');
    for (final item in pending) {
      debugPrint('➡ ID: ${item.id}, title: ${item.title}, body: ${item.body}');
    }
  }

  Future<void> cancelDebugNotification() async {
    await flutterLocalNotificationsPlugin.cancel(id: 777);
  }

  Future<void> openExactAlarmSettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    await intent.launch();
  }

  Future<void> cancelExactTestNotification() async {
    await flutterLocalNotificationsPlugin.cancel(id: 999);
  }

  Future<void> initNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
    );
  }



  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }


  Future<void> testScheduleIn1Minute() async {
    final scheduledDate =
    tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 500,
      title: 'Test',
      body: 'Debe llegar en 1 minuto',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'test',
          'test',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Recordatorio diario',
      channelDescription: 'Recordatorio para registrar emociones',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Si la hora ya pasó hoy → programar para mañana
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: 100,
        title: 'Bloomind',
        body: 'No olvides registrar tu emoción de hoy 💙',
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e, st) {
      debugPrint('ERROR zonedSchedule: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> cancelDailyNotification() async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id: 100);
    } catch (e, st) {
      debugPrint('Error cancelando recordatorio diario: $e');
      debugPrintStack(stackTrace: st);
    }
}



  Future<void> initTimezone() async {
    tz.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    String zoneId;

    try {
      zoneId = timezoneInfo.identifier;
    } catch (_) {
      final raw = timezoneInfo.toString();
      final match = RegExp(r'TimezoneInfo\(([^,]+),').firstMatch(raw);
      zoneId = match?.group(1) ?? raw;
    }

    zoneId = zoneId.trim();

    if (zoneId == 'GMT' || zoneId == 'UTC') {
      zoneId = 'Etc/UTC';
    }

    debugPrint('RAW TIMEZONE: $timezoneInfo');
    debugPrint('ZONE ID FINAL: $zoneId');

    tz.setLocalLocation(tz.getLocation(zoneId));
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
      id: 0,
      title: 'Bloomind',
      body: 'Esta es una notificación de prueba',
      notificationDetails: details,
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
      id: 1,
      title: 'Bloomind',
      body: 'Recordatorio en 5 segundos',
      scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
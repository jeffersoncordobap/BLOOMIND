import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferences {
  static const String dailyReminderKey = 'daily_reminder_enabled';
  static const String dailyHourKey = 'daily_reminder_hour';
  static const String dailyMinuteKey = 'daily_reminder_minute';

  static const String activityReminderKey = 'activity_reminder_enabled';
  static const String activityMinutesKey = 'activity_reminder_minutes';

  Future<void> saveSettings({
    required bool dailyReminder,
    required TimeOfDay selectedTime,
    required bool activityReminder,
    required int selectedMinutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(dailyReminderKey, dailyReminder);
    await prefs.setInt(dailyHourKey, selectedTime.hour);
    await prefs.setInt(dailyMinuteKey, selectedTime.minute);

    await prefs.setBool(activityReminderKey, activityReminder);
    await prefs.setInt(activityMinutesKey, selectedMinutes);
  }

  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final bool dailyReminder =
        prefs.getBool(dailyReminderKey) ?? false;
    final int dailyHour =
        prefs.getInt(dailyHourKey) ?? 9;
    final int dailyMinute =
        prefs.getInt(dailyMinuteKey) ?? 0;

    final bool activityReminder =
        prefs.getBool(activityReminderKey) ?? false;
    final int selectedMinutes =
        prefs.getInt(activityMinutesKey) ?? 5;

    return {
      'dailyReminder': dailyReminder,
      'selectedTime': TimeOfDay(hour: dailyHour, minute: dailyMinute),
      'activityReminder': activityReminder,
      'selectedMinutes': selectedMinutes,
    };
  }
}
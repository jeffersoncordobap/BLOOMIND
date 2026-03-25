import 'package:flutter/material.dart';
import 'package:bloomind/features/notifications/data/notification_preferences.dart';
import 'package:bloomind/core/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();

}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen>
    with TickerProviderStateMixin {
  bool dailyReminder = false;
  bool activityReminder = false;

  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  int selectedMinutes = 5;

  bool _savedDailyReminder = false;
  bool _savedActivityReminder = false;
  TimeOfDay _savedSelectedTime = const TimeOfDay(hour: 9, minute: 0);
  int _savedSelectedMinutes = 5;

  final NotificationPreferences _preferences = NotificationPreferences();
  bool _isLoading = true;

  bool get _hasChanges {
    return dailyReminder != _savedDailyReminder ||
        activityReminder != _savedActivityReminder ||
        selectedTime.hour != _savedSelectedTime.hour ||
        selectedTime.minute != _savedSelectedTime.minute ||
        selectedMinutes != _savedSelectedMinutes;
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<bool> _ensureNotificationPermission() async {
    final granted =
    await NotificationService.instance.requestNotificationPermission();

    if (granted) return true;

    if (!context.mounted) return false;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permiso requerido'),
        content: const Text(
          'Las notificaciones están desactivadas. '
              'Actívalas en la configuración de la app para recibir recordatorios.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await NotificationService.instance.openNotificationSettings();
            },
            child: const Text('Abrir ajustes'),
          ),
        ],
      ),
    );

    return false;
  }





  Future<void> _loadSettings() async {
    final data = await _preferences.loadSettings();

    setState(() {
      dailyReminder = data['dailyReminder'] as bool;
      selectedTime = data['selectedTime'] as TimeOfDay;
      activityReminder = data['activityReminder'] as bool;
      selectedMinutes = data['selectedMinutes'] as int;

      _savedDailyReminder = dailyReminder;
      _savedActivityReminder = activityReminder;
      _savedSelectedTime = selectedTime;
      _savedSelectedMinutes = selectedMinutes;

      _isLoading = false;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _saveSettings() async {
    final needsNotifications = dailyReminder || activityReminder;

    if (needsNotifications) {
      final granted = await _ensureNotificationPermission();
      if (!granted) return;
    }

    await _preferences.saveSettings(
      dailyReminder: dailyReminder,
      selectedTime: selectedTime,
      activityReminder: activityReminder,
      selectedMinutes: selectedMinutes,
    );

    // RECORDATORIO DIARIO
    if (dailyReminder) {
      await NotificationService.instance.scheduleDailyNotification(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );
    } else {
      await NotificationService.instance.cancelDailyNotification();
    }

    // ACTIVIDADES DEL DÍA
    if (activityReminder) {
      final dayRoutineController = context.read<DayRoutineController>();
      final activities = dayRoutineController.dayActivities;

      await NotificationService.instance.cancelActivityNotifications();

      await NotificationService.instance.scheduleActivitiesNotifications(
        activities: activities,
        minutesBefore: selectedMinutes,
      );
    } else {
      await NotificationService.instance.cancelActivityNotifications();
    }

    final pending =
    await NotificationService.instance.getPendingNotifications();

    debugPrint('🔔 Notificaciones pendientes: ${pending.length}');
    for (final item in pending) {
      debugPrint(
        'ID: ${item.id}, title: ${item.title}, body: ${item.body}',
      );
    }

    setState(() {
      _savedDailyReminder = dailyReminder;
      _savedActivityReminder = activityReminder;
      _savedSelectedTime = selectedTime;
      _savedSelectedMinutes = selectedMinutes;
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración guardada')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            color: Color(0xFF2F3B52),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2F3B52)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
      _isLoading
          ? const Center(child: CircularProgressIndicator())
      :Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              18,
              20,
              _hasChanges ? 120 : 32,
            ),
            child: Column(
              children: [
                _NotificationSectionCard(
                  title: 'Recordatorio diario',
                  subtitle: 'Recuerda registrar tu emoción cada día',
                  icon: Icons.favorite_rounded,
                  iconBackground: const Color(0xFFE8F1FF),
                  iconColor: const Color(0xFF5E8FD0),
                  value: dailyReminder,
                  onChanged: (value) {
                    setState(() {
                      dailyReminder = value;
                    });
                  },
                  summaryText: dailyReminder
                      ? 'Te avisaremos cada día a las ${_formatTime(selectedTime)}.'
                      : null,
                  child: _SmoothExpand(
                    expanded: dailyReminder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        const Divider(
                          color: Color(0xFFE1E7EF),
                          height: 1,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Hora del recordatorio',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF607086),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _pickTime,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFD),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFD9E2EC),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF2FE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.schedule_rounded,
                                    color: Color(0xFF6A97D7),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _formatTime(selectedTime),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF27364D),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF93A1B5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                _NotificationSectionCard(
                  title: 'Actividades del día',
                  subtitle: 'Recibe un aviso antes de cada actividad',
                  icon: Icons.event_note_rounded,
                  iconBackground: const Color(0xFFEFF6EC),
                  iconColor: const Color(0xFF79A862),
                  value: activityReminder,
                  onChanged: (value) {
                    setState(() {
                      activityReminder = value;
                    });
                  },
                  summaryText: activityReminder
                      ? 'Te avisaremos $selectedMinutes minutos antes de cada actividad.'
                      : null,
                  child: _SmoothExpand(
                    expanded: activityReminder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        const Divider(
                          color: Color(0xFFE1E7EF),
                          height: 1,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Avisar con anticipación',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF607086),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [5, 10, 15, 30].map((minutes) {
                            final isSelected = selectedMinutes == minutes;
                            return _MinuteChip(
                              label: '$minutes',
                              selected: isSelected,
                              onTap: () {
                                setState(() {
                                  selectedMinutes = minutes;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            left: 20,
            right: 20,
            bottom: _hasChanges ? 16 : -90,
            child: IgnorePointer(
              ignoring: !_hasChanges,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: _hasChanges ? 1 : 0,
                child: SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFFE0E6EE),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5F93D3),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Guardar cambios',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'a.m.' : 'p.m.';
    return '$hour:$minute $period';
  }
}

class _NotificationSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;
  final String? summaryText;

  const _NotificationSectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.value,
    required this.onChanged,
    required this.child,
    this.summaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE7ECF2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF24344D),
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF72839A),
                          height: 1.35,
                        ),
                      ),
                      if (summaryText != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F8FC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFE0E8F2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.notifications_active_rounded,
                                size: 18,
                                color: Color(0xFF6A97D7),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  summaryText!,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5D7088),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _CustomToggle(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomToggle({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: 58,
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF6A9BDA) : const Color(0xFFE4E8EE),
          borderRadius: BorderRadius.circular(30),
          boxShadow: value
              ? const [
            BoxShadow(
              color: Color(0x226A9BDA),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: value
                  ? const Icon(
                Icons.check_rounded,
                key: ValueKey('active_icon'),
                size: 15,
                color: Color(0xFF6A9BDA),
              )
                  : const SizedBox(
                key: ValueKey('empty_icon'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MinuteChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MinuteChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: 70,
        height: 56,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5F93D3) : const Color(0xFFF7F9FB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFF5F93D3) : const Color(0xFFDCE4ED),
          ),
          boxShadow: selected
              ? const [
            BoxShadow(
              color: Color(0x225F93D3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : const Color(0xFF25354D),
          ),
        ),
      ),
    );
  }
}

class _SmoothExpand extends StatelessWidget {
  final bool expanded;
  final Widget child;

  const _SmoothExpand({
    required this.expanded,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: expanded ? 1 : 0,
          child: child,
        ),
      ),
    );
  }
}
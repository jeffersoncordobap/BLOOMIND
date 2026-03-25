import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/activities/controller/activity_controller.dart';
import 'package:bloomind/features/settings/controller/bin_controller.dart';
import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
import 'package:bloomind/features/routines/presentation/provider/routine_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnlyActivitiesRemovedScreen extends StatefulWidget {
  const OnlyActivitiesRemovedScreen({super.key});

  @override
  State<OnlyActivitiesRemovedScreen> createState() =>
      _OnlyActivityRemovedScreenState();
}

class _OnlyActivityRemovedScreenState
    extends State<OnlyActivitiesRemovedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BinController>().loadDeletedActivities();
    });
  }

  void _showOptionsDialog(Activity activity) {
    final binController = context.read<BinController>();
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.restore_from_trash,
                color: colorScheme.primary,
              ),
              title: Text(
                "Restaurar",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onTap: () async {
                Navigator.pop(dialogContext);
                await binController.restoreActivity(activity.idActivity!);
                if (mounted) {
                  context.read<ActivityController>().loadCategories();
                  context.read<DayRoutineController>().loadTodayRoutine();
                  try {
                    context.read<RoutineProvider>().updateUpcomingActivity();
                  } catch (e) {
                    debugPrint("RoutineProvider no encontrado: $e");
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Actividad restaurada correctamente',
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                      backgroundColor:
                          colorScheme.surface.withValues(alpha: 0.95),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_forever,
                color: colorScheme.error,
              ),
              title: Text(
                "Eliminar definitivamente",
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(dialogContext);
                binController.forceDeleteActivity(activity.idActivity!);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BinController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Papelera de actividades",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Aquí puedes ver las actividades que has eliminado. Restáuralas si fue un error.",
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.deletedActivities.isEmpty
                    ? Center(
                        child: Text(
                          "No tienes actividades eliminadas",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.deletedActivities.length,
                        itemBuilder: (context, index) {
                          final activity = controller.deletedActivities[index];
                          return GestureDetector(
                            onLongPress: () => _showOptionsDialog(activity),
                            child: _DeleteActivityCard(activity: activity),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _DeleteActivityCard extends StatelessWidget {
  final Activity activity;
  const _DeleteActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(activity.emoji, style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.restore_from_trash_rounded,
              color: colorScheme.secondary,
            ),
            tooltip: "Restaurar",
            onPressed: () async {
              await context.read<BinController>().restoreActivity(
                    activity.idActivity!,
                  );

              if (context.mounted) {
                context.read<ActivityController>().loadCategories();
                try {
                  context.read<DayRoutineController>().loadTodayRoutine();
                } catch (e) {
                  debugPrint("DayRoutineController no encontrado: $e");
                }
                try {
                  context.read<RoutineProvider>().updateUpcomingActivity();
                } catch (_) {}

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Actividad restaurada',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    backgroundColor:
                        colorScheme.surface.withValues(alpha: 0.95),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
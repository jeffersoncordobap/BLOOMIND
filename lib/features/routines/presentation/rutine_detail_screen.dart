import 'package:bloomind/features/activities/controller/activity_controller.dart';
import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/activities/presentation/activity_form_screen.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;
  const RoutineDetailScreen({super.key, required this.routine});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityController>().fetchActivitiesByRoutine(
        widget.routine.idRoutine!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityController = context.watch<ActivityController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.routine.name,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: activityController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : activityController.currentRoutineActivities.isEmpty
              ? _buildEmptyState(colorScheme)
              : _buildActivityList(
                  activityController.currentRoutineActivities, colorScheme),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Esta rutina aún no tiene actividades",
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          _buildAddActivityButton(colorScheme),
        ],
      ),
    );
  }

  Widget _buildActivityList(List<Activity> activities, ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: activities.length + 1,
      itemBuilder: (context, index) {
        if (index == activities.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _buildAddActivityButton(colorScheme),
          );
        }

        final activity = activities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Text(activity.emoji, style: const TextStyle(fontSize: 35)),
                const SizedBox(width: 20),
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
                        "${activity.hour} · ${activity.category}",
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert,
                      color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToEdit(activity);
                    } else if (value == 'delete') {
                      _confirmDeletion(activity, colorScheme);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined,
                            color: colorScheme.onSurface),
                        title: Text("Editar",
                            style: TextStyle(color: colorScheme.onSurface)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text(
                          "Eliminar",
                          style: TextStyle(color: Colors.red),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeletion(Activity activity, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "¿Eliminar actividad?",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Text(
          "¿Estás seguro de eliminar '${activity.name}'? Esta acción no se puede deshacer.",
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "Cancelar",
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final screenContext = context;
              Navigator.pop(dialogContext);
              screenContext.read<ActivityController>().removeActivity(
                    activity.idActivity!,
                    widget.routine.idRoutine!,
                    screenContext,
                  );
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(Activity activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityScreen(
          idRoutine: widget.routine.idRoutine!,
          activityToEdit: activity,
        ),
      ),
    );
  }

  Widget _buildAddActivityButton(ColorScheme colorScheme) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ActivityScreen(idRoutine: widget.routine.idRoutine!),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: colorScheme.onPrimary),
              const SizedBox(width: 10),
              Text(
                "Agregar actividad",
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
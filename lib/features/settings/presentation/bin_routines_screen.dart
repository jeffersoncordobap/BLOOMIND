import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
import 'package:bloomind/features/routines/controller/routine_controller.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/presentation/provider/routine_provider.dart';
import 'package:bloomind/features/settings/controller/bin_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BinRoutinesScreen extends StatefulWidget {
  const BinRoutinesScreen({super.key});

  @override
  State<BinRoutinesScreen> createState() => _BinRoutinesScreenState();
}

class _BinRoutinesScreenState extends State<BinRoutinesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BinController>().loadDeletedRoutines();
    });
  }

  void _showOptionsDialog(Routine routine) {
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
              leading: Icon(Icons.restore_from_trash, color: colorScheme.primary),
              title: Text("Restaurar", style: TextStyle(color: colorScheme.onSurface)),
              onTap: () async {
                Navigator.pop(dialogContext);
                await binController.restoreRoutine(routine.idRoutine!);

                if (mounted) {
                  try {
                    context.read<RoutineController>().fetchRoutines();
                  } catch (_) {}
                  try {
                    context.read<RoutineProvider>().updateUpcomingActivity();
                  } catch (_) {}
                  try {
                    context.read<DayRoutineController>().loadTodayRoutine();
                  } catch (_) {}

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rutina restaurada correctamente')),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: colorScheme.error),
              title: Text("Eliminar definitivamente", style: TextStyle(color: colorScheme.error)),
              onTap: () {
                Navigator.pop(dialogContext);
                binController.forceDeleteRoutine(routine.idRoutine!);
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
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        title: Text(
          "Papelera de rutinas",
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
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
              "Aquí puedes ver las rutinas que has eliminado.",
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
                : controller.deletedRoutines.isEmpty
                    ? Center(
                        child: Text(
                          "No tienes rutinas eliminadas",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.deletedRoutines.length,
                        itemBuilder: (context, index) {
                          final routine = controller.deletedRoutines[index];
                          return GestureDetector(
                            onLongPress: () => _showOptionsDialog(routine),
                            child: _DeleteRoutineCard(routine: routine),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _DeleteRoutineCard extends StatelessWidget {
  final Routine routine;
  const _DeleteRoutineCard({required this.routine});

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
            child: const Text("🏋️‍♂️", style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              routine.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.restore_from_trash_rounded,
              color: colorScheme.primary,
            ),
            tooltip: "Restaurar",
            onPressed: () async {
              await context.read<BinController>().restoreRoutine(routine.idRoutine!);
              if (context.mounted) {
                try {
                  context.read<RoutineController>().fetchRoutines();
                } catch (_) {}
                try {
                  context.read<RoutineProvider>().updateUpcomingActivity();
                } catch (_) {}
                try {
                  context.read<DayRoutineController>().loadTodayRoutine();
                } catch (_) {}
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rutina restaurada')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
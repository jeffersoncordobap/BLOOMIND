import 'package:bloomind/features/activities/presentation/activity_form_screen.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/day_routine_controller.dart';

class DayRoutineScreen extends StatefulWidget {
  const DayRoutineScreen({super.key});

  @override
  State<DayRoutineScreen> createState() => _DayRoutineScreenState();
}

class _DayRoutineScreenState extends State<DayRoutineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DayRoutineController>().loadTodayRoutine();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DayRoutineController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Rutina del día",
          style: TextStyle(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(1);
          },
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(controller, colorScheme),
    );
  }

  Widget _buildContent(DayRoutineController controller, ColorScheme colorScheme) {
    if (controller.dayActivities.isEmpty) {
      return _buildEmptyState(colorScheme);
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: controller.dayActivities.length,
            itemBuilder: (context, index) {
              final activity = controller.dayActivities[index];
              return _buildActivityCard(activity, colorScheme);
            },
          ),
        ),
        _buildAddActivityButton(colorScheme),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildActivityCard(dynamic activity, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(activity.emoji, style: TextStyle(fontSize: 28)),
            ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildAddActivityButton(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () {
            final routineId =
                context.read<DayRoutineController>().currentRoutineId;
            if (routineId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityScreen(idRoutine: routineId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Asigna una rutina a este día para agregar actividades",
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  backgroundColor: colorScheme.surface,
                ),
              );
            }
          },
          icon: Icon(Icons.add, color: colorScheme.onPrimary),
          label: Text(
            "Agregar actividad",
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "😊 Hoy no tienes una rutina asignada",
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          _buildAddActivityButton(colorScheme),
        ],
      ),
    );
  }
}
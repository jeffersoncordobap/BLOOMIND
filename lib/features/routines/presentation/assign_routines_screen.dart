import 'package:bloomind/features/routines/controller/assing_routine_controller.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssignRoutineScreen extends StatefulWidget {
  const AssignRoutineScreen({super.key});

  @override
  State<AssignRoutineScreen> createState() => _AssignRoutineScreenState();
}

class _AssignRoutineScreenState extends State<AssignRoutineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignRoutineController>().loadRoutines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssignRoutineController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(1);
          },
        ),
        title: Text(
          "Asignar rutinas",
          style: TextStyle(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildCalendarCard(controller, colorScheme),
                  const SizedBox(height: 30),
                  Text(
                    "Selecciona una rutina",
                    style: TextStyle(
                      color: colorScheme.onBackground.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRoutineDropdown(controller, colorScheme),
                  const SizedBox(height: 40),
                  _buildAssignButton(controller, colorScheme),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildCalendarCard(
      AssignRoutineController controller, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: CalendarDatePicker(
          initialDate: controller.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          onDateChanged: (DateTime date) {
            controller.updateSelectedDate(date);
          },
        ),
      ),
    );
  }

  Widget _buildRoutineDropdown(
      AssignRoutineController controller, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colorScheme.outline),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Routine>(
          isExpanded: true,
          value: controller.availableRoutines.contains(controller.selectedRoutine)
              ? controller.selectedRoutine
              : null,
          hint: Text(
            "Seleccionar",
            style: TextStyle(color: colorScheme.onSurface),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.onSurface),
          items: controller.availableRoutines.map((routine) {
            return DropdownMenuItem<Routine>(
              value: routine,
              child: Text(
                routine.name,
                style: TextStyle(color: colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: (val) => controller.updateSelectedRoutine(val),
        ),
      ),
    );
  }

  Widget _buildAssignButton(
      AssignRoutineController controller, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () async {
          if (controller.selectedRoutine == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                "Por favor selecciona una rutina",
                style: TextStyle(color: colorScheme.onPrimary),
              )),
            );
            return;
          }

          bool ok = await controller.saveAssignment(context);
          if (ok && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                "¡Rutina asignada correctamente!",
                style: TextStyle(color: colorScheme.onPrimary),
              )),
            );
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(1);
          }
        },
        child: Text(
          "Asignar rutina",
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
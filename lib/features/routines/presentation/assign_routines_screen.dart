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
    // Cargamos las rutinas de la DB cada vez que se inicializa la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignRoutineController>().loadRoutines();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios del controlador
    final controller = context.watch<AssignRoutineController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(1);
          },
        ),
        title: const Text(
          "Asignar rutinas",
          style: TextStyle(
            color: Color(0xFF2D3142),
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

                  // 1. EL CALENDARIO
                  _buildCalendarCard(controller),

                  const SizedBox(height: 30),

                  const Text(
                    "Selecciona una rutina",
                    style: TextStyle(color: Color(0xFF7D8FA9), fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  // 2. EL DROPDOWN (Corregido e integrado)
                  _buildRoutineDropdown(controller),

                  const SizedBox(height: 40),

                  // 3. EL BOTÓN
                  _buildAssignButton(controller),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildCalendarCard(AssignRoutineController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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

  Widget _buildRoutineDropdown(AssignRoutineController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFB8C8DF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Routine>(
          isExpanded: true,
          // Validación crítica: evita errores si la rutina seleccionada fue eliminada
          value:
              controller.availableRoutines.contains(controller.selectedRoutine)
              ? controller.selectedRoutine
              : null,
          hint: const Text(
            "Seleccionar",
            style: TextStyle(color: Color(0xFF2D3142)),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2D3142)),
          items: controller.availableRoutines.map((routine) {
            return DropdownMenuItem<Routine>(
              value: routine,
              child: Text(routine.name),
            );
          }).toList(),
          onChanged: (val) => controller.updateSelectedRoutine(val),
        ),
      ),
    );
  }

  Widget _buildAssignButton(AssignRoutineController controller) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF75B1EA),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () async {
          if (controller.selectedRoutine == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Por favor selecciona una rutina")),
            );
            return;
          }

          bool ok = await controller.saveAssignment();
          if (ok && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("¡Rutina asignada correctamente!")),
            );
          }
        },
        child: const Text(
          "Asignar rutina",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

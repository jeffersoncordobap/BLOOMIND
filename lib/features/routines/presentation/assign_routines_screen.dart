import 'package:bloomind/features/routines/controller/assing_routine_controller.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/repository/assign_routine_repository_impl.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';
import 'package:flutter/material.dart';

class AssignRoutineScreen extends StatefulWidget {
  const AssignRoutineScreen({super.key});

  @override
  State<AssignRoutineScreen> createState() => _AssignRoutineScreenState();
}

class _AssignRoutineScreenState extends State<AssignRoutineScreen> {
  late AssignRoutineController controller;

  @override
  void initState() {
    super.initState();
    controller = AssignRoutineController(
      routineRepo: RoutineRepositoryImpl(),
      assignRepo: AssignRoutineRepositoryImpl(),
    );
    controller.loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Asignar Rutina")),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.isLoading)
            return const Center(child: CircularProgressIndicator());

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "1. Selecciona la fecha",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildCalendarTile(),

                const SizedBox(height: 30),

                const Text(
                  "2. Selecciona la rutina",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildRoutineDropdown(),

                const Spacer(),

                _buildSaveButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget para mostrar y cambiar la fecha
  Widget _buildCalendarTile() {
    return ListTile(
      tileColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: const Icon(Icons.calendar_today, color: Colors.blue),
      title: Text(
        "${controller.selectedDate.day}/${controller.selectedDate.month}/${controller.selectedDate.year}",
      ),
      trailing: const Text("Cambiar", style: TextStyle(color: Colors.blue)),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: controller.selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null) controller.updateSelectedDate(picked);
      },
    );
  }

  // Dropdown que se llena con las rutinas de la base de datos
  Widget _buildRoutineDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Routine>(
          isExpanded: true,
          hint: const Text("Elegir rutina"),
          value: controller.selectedRoutine,
          items: controller.availableRoutines.map((Routine routine) {
            return DropdownMenuItem<Routine>(
              value: routine,
              child: Text(routine.name),
            );
          }).toList(),
          onChanged: (Routine? newValue) =>
              controller.updateSelectedRoutine(newValue),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4D86C7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: () async {
          bool success = await controller.saveAssignment();
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Rutina asignada correctamente")),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Por favor selecciona una rutina")),
            );
          }
        },
        child: const Text(
          "GUARDAR ASIGNACIÓN",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

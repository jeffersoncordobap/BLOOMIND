import 'package:bloomind/features/routines/controller/assing_routine_controller.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/repository/assign_routine_repository_impl.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';
import 'package:bloomind/main_navegator_screen.dart';
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
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // 1. EL CALENDARIO (Cuadro blanco central)
                _buildCalendarCard(),

                const SizedBox(height: 30),

                const Text(
                  "Selecciona una rutina",
                  style: TextStyle(color: Color(0xFF7D8FA9), fontSize: 16),
                ),
                const SizedBox(height: 12),

                // 2. EL DROPDOWN (Seleccionar)
                _buildRoutineDropdown(),

                const SizedBox(height: 40),

                // 3. EL BOTÓN (Asignar rutina)
                _buildAssignButton(),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      // Mantenemos tu BottomNavigationBar aquí si la tienes
      // bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildCalendarCard() {
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

  Widget _buildRoutineDropdown() {
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
          value: controller.selectedRoutine,
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

  Widget _buildAssignButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(
            255,
            117,
            177,
            234,
          ), // Color azul pastel del diseño
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () async {
          bool ok = await controller.saveAssignment();
          if (ok)
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Asignada!")));
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

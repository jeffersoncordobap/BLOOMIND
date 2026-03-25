import 'package:bloomind/features/routines/controller/assing_routine_controller.dart';
import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/presentation/provider/routine_provider.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineController extends ChangeNotifier {
  final RoutineRepositoryImpl repository;
  List<Routine> routines = [];
  bool isLoading = false;

  RoutineController({required this.repository});
  Future<void> fetchRoutines() async {
    isLoading = true;
    notifyListeners();
    try {
      routines = await repository.getAllRoutines();
    } catch (e) {
      debugPrint("Error al obtener rutinas: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRoutine(String name, BuildContext context) async {
    try {
      final newRoutine = Routine(name: name);
      final result = await repository.createRoutine(newRoutine);

      if (result == -1) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "❗Ya existe una rutina con ese nombre",
                style: const TextStyle(
                  color: Color.fromARGB(255, 222, 32, 32),
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 244, 168, 177),
            ),
          );
        }
        return;
      }
      await fetchRoutines();
      if (context.mounted) {
        context.read<AssignRoutineController>().loadRoutines();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rutina creada con éxito")),
        );
      }
    } catch (e) {
      debugPrint("Error al crear: $e");
    }
  }

  Future<void> removeRoutine(int id, BuildContext context) async {
    try {
      // 1. Eliminar (Soft Delete)
      await repository.deleteRoutine(id);

      // 2. Actualizar lista local de rutinas
      await fetchRoutines();

      if (context.mounted) {
        // 3. Actualizar otras pantallas dependientes:

        // A. Actualizar dropdowns de asignación
        try {
          context.read<AssignRoutineController>().loadRoutines();
        } catch (e) {
          debugPrint("AssignRoutineController no encontrado: $e");
        }

        // B. Actualizar Rutina del Día (Si la rutina eliminada era la de hoy, la pantalla se vaciará)
        try {
          context.read<DayRoutineController>().loadTodayRoutine();
        } catch (e) {
          debugPrint("DayRoutineController no encontrado: $e");
        }

        // C. Actualizar Tarjeta de Próxima Actividad (Se mostrará "Rutina no disponible")
        try {
          context.read<RoutineProvider>().updateUpcomingActivity();
        } catch (e) {
          debugPrint("RoutineProvider no encontrado: $e");
        }
      }

      debugPrint("Rutina $id eliminada y estados sincronizados.");
    } catch (e) {
      debugPrint("Error al eliminar: $e");
    }
  }
}

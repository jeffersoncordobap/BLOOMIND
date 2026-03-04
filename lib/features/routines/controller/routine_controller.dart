import 'package:bloomind/features/routines/controller/assing_routine_controller.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineController extends ChangeNotifier {
  final RoutineRepositoryImpl repository;
  List<Routine> routines = [];
  bool isLoading = false;

  RoutineController({required this.repository});

  // Cargar rutinas de la DB
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
      await repository.deleteRoutine(id);
      await fetchRoutines();
      if (context.mounted) {
        context.read<AssignRoutineController>().loadRoutines();
      }

      debugPrint("Rutina $id eliminada y estados sincronizados.");
    } catch (e) {
      debugPrint("Error al eliminar: $e");
    }
  }
}

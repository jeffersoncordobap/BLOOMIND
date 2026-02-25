import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';
import 'package:flutter/material.dart';

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

  // Crear rutina y refrescar
  Future<void> addRoutine(String name) async {
    try {
      final newRoutine = Routine(name: name);
      await repository.createRoutine(newRoutine);
      await fetchRoutines();
    } catch (e) {
      debugPrint("Error al crear: $e");
    }
  }

  // Eliminar rutina y refrescar
  Future<void> removeRoutine(int id) async {
    try {
      await repository.deleteRoutine(id);
      await fetchRoutines();
    } catch (e) {
      debugPrint("Error al eliminar: $e");
    }
  }
}

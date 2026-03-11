import 'package:flutter/material.dart';
import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/routines/repository/assign_routine_repository_impl.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';

class DayRoutineController extends ChangeNotifier {
  final AssignRoutineRepositoryImpl assignRepo;
  final RoutineRepositoryImpl routineRepo;

  List<Activity> dayActivities = [];
  bool isLoading = false;
  int? currentRoutineId;

  DayRoutineController({required this.assignRepo, required this.routineRepo});

  Future<void> loadTodayRoutine() async {
    isLoading = true;
    notifyListeners();

    try {
      // Obtenemos solo YYYY-MM-DD
      final todayStr = DateTime.now().toIso8601String().split('T')[0];

      // 1. Buscamos la asignación de hoy
      final assignment = await assignRepo.getAssignmentByDate(todayStr);

      if (assignment != null) {
        // 2. GUARDAMOS EL ID
        currentRoutineId = assignment.idRoutine;

        // 3. Cargamos las actividades
        dayActivities = await routineRepo.getActivitiesByRoutine(
          assignment.idRoutine,
        );
      } else {
        currentRoutineId = null;
        dayActivities = [];
      }
    } catch (e) {
      debugPrint("Error cargando rutina de hoy: $e");
      currentRoutineId = null;
      dayActivities = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

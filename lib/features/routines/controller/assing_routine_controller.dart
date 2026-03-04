import 'package:bloomind/features/routines/model/assing_routine.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/repository/assign_routine_repository_impl.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';
import 'package:flutter/material.dart';

class AssignRoutineController extends ChangeNotifier {
  final RoutineRepositoryImpl routineRepo;
  final AssignRoutineRepositoryImpl assignRepo;

  List<Routine> availableRoutines = [];
  Routine? selectedRoutine;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  AssignRoutineController({
    required this.routineRepo,
    required this.assignRepo,
  });

  Future<void> loadRoutines() async {
    availableRoutines = [];
    isLoading = true;
    notifyListeners();

    try {
      availableRoutines = await routineRepo.getAllRoutines();
      if (selectedRoutine != null) {
        bool existe = availableRoutines.any(
          (r) => r.idRoutine == selectedRoutine!.idRoutine,
        );
        if (!existe) {
          selectedRoutine = null;
        }
      }
    } catch (e) {
      debugPrint("Error cargando rutinas: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedRoutine(Routine? routine) {
    selectedRoutine = routine;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  Future<bool> saveAssignment() async {
    if (selectedRoutine == null) return false;
    String dateOnly = selectedDate.toIso8601String().split('T')[0];
    final existing = await assignRepo.getAssignmentByDate(dateOnly);

    if (existing != null) {
      await assignRepo.removeAssignment(existing.idAssignRoutine!);
    }

    final assignment = AssignRoutine(
      dateTime: selectedDate.toIso8601String(),
      idRoutine: selectedRoutine!.idRoutine!,
    );

    final result = await assignRepo.assignRoutineToDate(assignment);
    return result > 0;
  }
}

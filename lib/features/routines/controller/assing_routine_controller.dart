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

  // Cargar las rutinas reales de la DB para el Dropdown
  Future<void> loadRoutines() async {
    isLoading = true;
    notifyListeners();
    availableRoutines = await routineRepo.getAllRoutines();
    isLoading = false;
    notifyListeners();
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

    final assignment = AssignRoutine(
      dateTime: selectedDate.toIso8601String(),
      idRoutine: selectedRoutine!.idRoutine!,
    );

    final result = await assignRepo.assignRoutineToDate(assignment);
    return result > 0;
  }
}

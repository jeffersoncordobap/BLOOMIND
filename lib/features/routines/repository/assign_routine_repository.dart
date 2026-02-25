import '../model/assing_routine.dart';

abstract class AssignRoutineRepository {
  // Asignar una rutina a una fecha
  Future<int> assignRoutineToDate(AssignRoutine assignment);

  // Obtener qué rutinas hay para un día específico (YYYY-MM-DD)
  Future<List<AssignRoutine>> getAssignmentsByDate(String date);

  // Obtener la asignación de rutina para una fecha específica (si existe)

  // Eliminar una asignación (ej: el usuario canceló la rutina ese día)
  Future<int> removeAssignment(int idAssign);
}

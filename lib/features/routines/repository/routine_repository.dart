import '../model/routine.dart';
import '../../activities/model/activity.dart';

abstract class RoutineRepository {
  // Crear una rutina base
  Future<int> createRoutine(Routine routine);

  // Obtener todas las rutinas con sus IDs
  Future<List<Routine>> getAllRoutines();

  // Vincular una actividad existente a una rutina
  Future<void> addActivityToRoutine(int idRoutine, int idActivity);

  // Obtener actividades de una rutina específica
  Future<List<Activity>> getActivitiesByRoutine(int idRoutine);

  // Eliminar una rutina (borrará sus vínculos)
  Future<int> deleteRoutine(int idRoutine);
}

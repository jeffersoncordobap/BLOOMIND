import '../model/activity.dart';

abstract class ActivityRepository {
  // Crear una nueva actividad
  Future<int> createActivity(Activity activity);

  // Obtener todas las actividades disponibles
  Future<List<Activity>> getAllActivities();

  // Editar una actividad (nombre, hora, emoji...)
  Future<int> updateActivity(Activity activity);

  // Eliminar actividad de la biblioteca
  Future<int> deleteActivity(int idActivity);

  // Buscar actividades por categoría (ej: "Relajación")
  Future<List<Activity>> getActivitiesByCategory(String category);

  // Obtener actividades asociadas a una rutina específica
  Future<List<Activity>> getActivitiesByRoutine(int idRoutine);

  // Guardar una actividad dentro de una rutina específica (crea la actividad y la asocia a la rutina)
  Future<void> linkActivityToRoutine(
    int idRoutine,
    int idActivity,
    String hour,
  );

  // Actualizar una actividad dentro de una rutina (puede cambiar nombre, hora, emoji...)
  Future<void> updateActivityFull(
    Activity activity,
    int idRoutine,
    String oldHour,
  ) async {}

  // Obtener actividades que han sido eliminadas (Papelera)
  Future<List<Activity>> getDeletedActivities();

  // Restaurar una actividad eliminada (state -> 1)
  Future<int> restoreActivity(int idActivity);

  // Eliminar permanentemente de la base de datos (Opcional, para vaciar papelera)
  Future<int> forceDeleteActivity(int idActivity);
}

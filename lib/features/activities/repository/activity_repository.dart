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
}

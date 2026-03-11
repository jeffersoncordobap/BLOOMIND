import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/activities/repository/activity_repository.dart';
import 'package:bloomind/features/activities/repository/activity_repository_impl.dart';
import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
import 'package:bloomind/features/routines/presentation/provider/routine_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityController extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepositoryImpl();

  List<DropdownMenuItem<String>> categoryItems = [];
  List<Activity> currentRoutineActivities = [];
  bool isLoading = false;
  Future<void> loadCategories() async {
    try {
      final activities = await _repository.getAllActivities();
      final uniqueCategories = activities
          .map((activity) => activity.category)
          .toSet()
          .toList();

      categoryItems = uniqueCategories.map((category) {
        return DropdownMenuItem<String>(value: category, child: Text(category));
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error al cargar categorías: $e");
    }
  }

  Future<void> fetchActivitiesByRoutine(int idRoutine) async {
    isLoading = true;
    notifyListeners();

    try {
      currentRoutineActivities = await _repository.getActivitiesByRoutine(
        idRoutine,
      );
    } catch (e) {
      debugPrint("Error al cargar actividades de la rutina: $e");
      currentRoutineActivities = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Activity>> obtener_recomendaciones(String categoria) async {
    final activities = await _repository.getAllActivities();
    final filtradas = activities
        .where(
          (a) =>
              a.category == categoria &&
              a.name.toLowerCase() != categoria.toLowerCase(),
        )
        .toList();

    filtradas.shuffle();
    return filtradas.take(3).toList();
  }

  Future<void> categoriasIniciales() async {
    final activities = await _repository.getAllActivities();

    if (activities.isEmpty) {
      Map<String, List<Map<String, String>>> datosIniciales = {
        "Salud": [
          {"name": "Tomar agua", "emoji": "💧"},
          {"name": "Tomar vitaminas", "emoji": "💊"},
          {"name": "Desayuno nutritivo", "emoji": "🍳"},
        ],
        "Bienestar": [
          {"name": "Estiramiento", "emoji": "🧘"},
          {"name": "Skin care", "emoji": "🧼"},
          {"name": "Caminata corta", "emoji": "🍃"},
        ],
        "Estudio": [
          {"name": "Repasar apuntes", "emoji": "📚"},
          {"name": "Practicar ejercicios", "emoji": "📝"},
          {"name": "Leer 10 páginas", "emoji": "📖"},
        ],
        "Entrenamiento": [
          {"name": "Rutina de pierna", "emoji": "🍗"},
          {"name": "Salir a correr", "emoji": "🏃"},
          {"name": "Entrenamiento de espalda", "emoji": "💪"},
        ],
        "Mindfulness": [
          {"name": "Meditación guiada", "emoji": "🧘‍♂️"},
          {"name": "Respiración profunda", "emoji": "🌬️"},
          {"name": "Diario de gratitud", "emoji": "🙏"},
        ],
      };

      for (var entry in datosIniciales.entries) {
        for (var act in entry.value) {
          await _repository.createActivity(
            Activity(
              name: act["name"]!,
              category: entry.key,
              emoji: act["emoji"]!,
              hour: "08:00 AM",
            ),
          );
        }
      }
    }
    await loadCategories();
  }

  Future<void> addCategory(String category) async {
    await _repository.createActivity(
      Activity(
        name: "Nueva actividad de $category",
        category: category,
        emoji: "✨",
        hour: "",
      ),
    );
    await loadCategories();
  }

  Future<void> removeCategory(String category) async {
    final activities = await _repository.getActivitiesByCategory(category);
    for (var a in activities) {
      if (a.idActivity != null) {
        await _repository.deleteActivity(a.idActivity!);
      }
    }
    await loadCategories();
  }

  Future<bool> saveActivityToRoutine({
    required int idRoutine,
    required String name,
    required String category,
    required String emoji,
    required String hour,
  }) async {
    try {
      final newActivity = Activity(
        name: name,
        category: category,
        emoji: emoji,
        hour: hour,
      );

      final idActivity = await _repository.createActivity(newActivity);
      await _repository.linkActivityToRoutine(idRoutine, idActivity, hour);
      await fetchActivitiesByRoutine(idRoutine);

      return true;
    } catch (e) {
      debugPrint("Error al guardar y vincular actividad: $e");
      return false;
    }
  }

  // Eliminar actividad físicamente y refrescar la lista de la rutina
  Future<void> removeActivity(
    int idActivity,
    int idRoutine,
    BuildContext context,
  ) async {
    try {
      await _repository.deleteActivity(idActivity);
      await fetchActivitiesByRoutine(idRoutine);
      if (context.mounted) {
        // Actualiza "Rutina del día"
        context.read<DayRoutineController>().loadTodayRoutine();

        // Actualiza la tarjeta de la pantalla principal
        context.read<RoutineProvider>().updateUpcomingActivity();
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error al eliminar actividad: $e");
    }
  }

  Future<bool> updateExistingActivity(
    Activity activity,
    int idRoutine,
    String oldHour,
  ) async {
    try {
      await _repository.updateActivityFull(activity, idRoutine, oldHour);
      await fetchActivitiesByRoutine(idRoutine);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}

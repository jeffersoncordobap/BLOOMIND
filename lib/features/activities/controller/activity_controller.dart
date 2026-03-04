import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/activities/repository/activity_repository.dart';
import 'package:bloomind/features/activities/repository/activity_repository_impl.dart';
import 'package:flutter/material.dart';

class ActivityController extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepositoryImpl();

  List<DropdownMenuItem<String>> categoryItems = [];
  List<Activity> currentRoutineActivities = [];
  bool isLoading = false;

  /// Carga las categorías únicas desde la base de datos para el Dropdown
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

  /// Carga las actividades vinculadas a una rutina específica (Usado en la pantalla de detalles)
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

  /// Genera sugerencias reales con emojis específicos según la categoría
  Future<List<Activity>> obtener_recomendaciones(String categoria) async {
    final activities = await _repository.getAllActivities();

    // Filtramos para que no sugiera actividades cuyo nombre sea igual a la categoría
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

  /// Inicializa la base de datos con actividades sugeridas de calidad
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

  /// Agrega una nueva categoría creando una actividad base descriptiva
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

  /// Elimina una categoría (borra sus actividades asociadas)
  Future<void> removeCategory(String category) async {
    final activities = await _repository.getActivitiesByCategory(category);
    for (var a in activities) {
      if (a.idActivity != null) {
        await _repository.deleteActivity(a.idActivity!);
      }
    }
    await loadCategories();
  }

  /// Guarda la actividad y la vincula a la rutina mediante la tabla intermedia
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

      // Refrescamos la lista local para que la pantalla de detalles se actualice
      await fetchActivitiesByRoutine(idRoutine);

      return true;
    } catch (e) {
      debugPrint("Error al guardar y vincular actividad: $e");
      return false;
    }
  }
}

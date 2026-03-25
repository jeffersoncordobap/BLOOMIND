import 'package:flutter/material.dart';
import '../../emotions/model/emotion.dart';
import '../../emotions/repository/emotion_repository.dart';
import '../../emotions/repository/emotion_repository_impl.dart';
import '../../activities/model/activity.dart';
import '../../activities/repository/activity_repository.dart';
import '../../activities/repository/activity_repository_impl.dart';

class BinController extends ChangeNotifier {
  final EmotionRepository _emotionRepository = EmotionRepositoryImpl();
  final ActivityRepository _activityRepository = ActivityRepositoryImpl();

  List<Emotion> _deletedEmotions = [];
  List<Emotion> get deletedEmotions => _deletedEmotions;

  List<Activity> _deletedActivities = [];
  List<Activity> get deletedActivities => _deletedActivities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Cargar lista de emociones en la papelera
  Future<void> loadDeletedEmotions() async {
    _isLoading = true;
    notifyListeners();
    try {
      _deletedEmotions = await _emotionRepository.getDeletedEmotions();
    } catch (e) {
      debugPrint("Error cargando papelera de emociones: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restaurar una emoción a la lista activa
  Future<void> restoreEmotion(int id) async {
    await _emotionRepository.restoreEmotion(id);
    await loadDeletedEmotions();
  }

  /// Eliminar definitivamente de la base de datos
  Future<void> forceDeleteEmotion(int id) async {
    await _emotionRepository.forceDeleteEmotion(id);
    await loadDeletedEmotions();
  }

  //Cargar lista de actividades eliminadas (Papelera)
  Future<void> loadDeletedActivities() async {
    _isLoading = true;
    notifyListeners();
    try {
      _deletedActivities = await _activityRepository.getDeletedActivities();
    } catch (e) {
      debugPrint("Error cargando papelera de actividades: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restaurar una actividad a la lista activa
  Future<void> restoreActivity(int id) async {
    await _activityRepository.restoreActivity(id);
    await loadDeletedActivities();
  }

  /// Eliminar definitivamente de la base de datos
  Future<void> forceDeleteActivity(int id) async {
    await _activityRepository.forceDeleteActivity(id);
    await loadDeletedActivities();
  }
}

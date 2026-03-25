import 'package:flutter/material.dart';
import '../../emotions/model/emotion.dart';
import '../../emotions/repository/emotion_repository.dart';
import '../../emotions/repository/emotion_repository_impl.dart';

class BinController extends ChangeNotifier {
  final EmotionRepository _emotionRepository = EmotionRepositoryImpl();

  List<Emotion> _deletedEmotions = [];
  List<Emotion> get deletedEmotions => _deletedEmotions;

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
}

import '../model/emotion.dart';

abstract class EmotionRepository {
  // Guardar una nueva emoción
  Future<int> addEmotion(Emotion emotion);

  // Obtener todas las emociones para el historial
  Future<List<Emotion>> getAllEmotions();

  // Editar una emoción existente
  Future<int> updateEmotion(Emotion emotion);

  // Eliminar una emoción
  Future<int> deleteEmotion(int idEmotion);

  // Obtener emociones de un día específico
  // Recibe un String en formato 'YYYY-MM-DD'
  Future<List<Emotion>> getEmotionsByDate(String date);
}

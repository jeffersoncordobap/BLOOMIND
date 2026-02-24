import 'package:flutter/material.dart';

import '../model/emotion.dart';
import '../repository/emotion_repository.dart';
import '../repository/emotion_repository_impl.dart';

class EmotionController {
  // Instanciamos el repositorio
  final EmotionRepository _repository = EmotionRepositoryImpl();
  final TextEditingController notaController = TextEditingController();

  int _obtenerNivelDeAnimo(String etiqueta) {
    switch (etiqueta.toLowerCase()) {
      case 'feliz':
        return 5;
      case 'neutral':
        return 4;
      case 'cansado':
        return 3;
      case 'triste':
        return 2;
      case 'enojado':
        return 1;
      case 'desmotivado':
        return 0;
      default:
        return 3; // Valor por defecto para emociones no reconocidas
    }
  }

  Future<bool> guardarEmocion(String? etiqueta) async {
    if (etiqueta == null) return false;

    try {
      final nuevaEmocion = Emotion(
        moodLevel: _obtenerNivelDeAnimo(etiqueta),
        label: etiqueta,
        note: notaController.text,
        dateTime: DateTime.now().toIso8601String(),
      );

      await _repository.addEmotion(nuevaEmocion);
      notaController.clear();
      // Imprime la emoción guardada y el estado actual de la base de datos solo para depuración
      print("Emoción guardada: ${nuevaEmocion.toMap()}");
      await _repository.getAllEmotions().then((emotions) {
        print("Emociones en la base de datos:");
        emotions.forEach((emotion) {
          print(emotion.toMap());
        });
      });

      return true;
    } catch (e) {
      debugPrint("Error al guardar emoción: $e");
      return false;
    }
  }

  void dispose() {
    notaController.dispose();
  }
}

import 'package:flutter/material.dart';
import '../model/emotion.dart';
import '../repository/emotion_repository.dart';
import '../repository/emotion_repository_impl.dart';

class EmotionController extends ChangeNotifier {
  final EmotionRepository _repository = EmotionRepositoryImpl();
  final TextEditingController notaController = TextEditingController();

  List<Emotion> emotionsForSelectedDay = [];

  Map<DateTime, List<Emotion>> _allEmotionsMap = {};
  Map<DateTime, List<Emotion>> get allEmotionsMap => _allEmotionsMap;

  bool isLoading = false;

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
        return 3;
    }
  }

  /// Carga todas las emociones para el calendario y las organiza por fecha
  Future<void> cargarTodosLosEventos() async {
    try {
      final todas = await _repository.getAllEmotions();
      final Map<DateTime, List<Emotion>> nuevoMapa = {};

      for (var emo in todas) {
        DateTime fecha = DateTime.parse(emo.dateTime);
        DateTime fechaNormalizada = DateTime(
          fecha.year,
          fecha.month,
          fecha.day,
        );

        if (nuevoMapa[fechaNormalizada] == null) {
          nuevoMapa[fechaNormalizada] = [];
        }
        nuevoMapa[fechaNormalizada]!.add(emo);
      }

      _allEmotionsMap = nuevoMapa;
      notifyListeners();
    } catch (e) {
      debugPrint("Error cargando eventos del calendario: $e");
    }
  }

  /// Consulta las emociones de un día específico para la lista inferior
  Future<void> cargarEmocionesPorFecha(DateTime fecha) async {
    isLoading = true;
    notifyListeners();

    try {
      String fechaFormateada = fecha.toIso8601String().split('T')[0];
      emotionsForSelectedDay = await _repository.getEmotionsByDate(
        fechaFormateada,
      );
    } catch (e) {
      debugPrint("Error al cargar emociones por fecha: $e");
      emotionsForSelectedDay = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Guarda una nueva emoción y actualiza el estado global
  Future<bool> guardarEmocion(String? etiqueta) async {
    if (etiqueta == null) return false;

    try {
      final ahora = DateTime.now();
      final nuevaEmocion = Emotion(
        moodLevel: _obtenerNivelDeAnimo(etiqueta),
        label: etiqueta,
        note: notaController.text,
        dateTime: ahora.toIso8601String(),
      );

      await _repository.addEmotion(nuevaEmocion);
      notaController.clear();

      // 1. Actualizamos los puntitos del calendario
      await cargarTodosLosEventos();

      // 2. Actualizamos la lista del día de hoy inmediatamente
      await cargarEmocionesPorFecha(ahora);

      return true;
    } catch (e) {
      debugPrint("Error al guardar emoción: $e");
      return false;
    }
  }

  @override
  void dispose() {
    notaController.dispose();
    super.dispose();
  }

  /// Elimina una emoción y refresca los datos
  Future<void> eliminarEmocion(int? id, DateTime fechaRegistro) async {
    if (id == null) return;

    try {
      await _repository.deleteEmotion(id);

      // Refrescamos ambos estados para que la UI se actualice
      await cargarTodosLosEventos();
      await cargarEmocionesPorFecha(fechaRegistro);

      notifyListeners();
    } catch (e) {
      debugPrint("Error al eliminar emoción: $e");
    }
  }

  /// Verifica si una fecha es el día de hoy
  bool esHoy(DateTime fecha) {
    final ahora = DateTime.now();
    return fecha.year == ahora.year &&
        fecha.month == ahora.month &&
        fecha.day == ahora.day;
  }

  Future<void> actualizarEmocion(Emotion emotion) async {
    if (!esHoy(DateTime.parse(emotion.dateTime))) {
      debugPrint("Intento de edición no permitido: La fecha no es hoy.");
      return;
    }

    try {
      await _repository.updateEmotion(emotion);
      await cargarTodosLosEventos();
      await cargarEmocionesPorFecha(DateTime.parse(emotion.dateTime));
      notifyListeners();
    } catch (e) {
      debugPrint("Error al actualizar: $e");
    }
  }
}

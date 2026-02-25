import 'package:flutter/material.dart';
import '../model/emotion.dart';
import '../repository/emotion_repository.dart';
import '../repository/emotion_repository_impl.dart';

class EmotionController extends ChangeNotifier {
  // Instanciamos el repositorio
  final EmotionRepository _repository = EmotionRepositoryImpl();
  final TextEditingController notaController = TextEditingController();

  // --- Variables de Estado ---

  // Lista de emociones para el día seleccionado en la UI
  List<Emotion> emotionsForSelectedDay = [];

  // Mapa para los puntos (eventos) del calendario
  Map<DateTime, List<Emotion>> _allEmotionsMap = {};
  Map<DateTime, List<Emotion>> get allEmotionsMap => _allEmotionsMap;

  bool isLoading = false;

  // --- Lógica de Negocio ---

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

  // --- Métodos de Carga ---

  /// Carga todas las emociones para dibujar los puntos en el calendario
  Future<void> cargarTodosLosEventos() async {
    try {
      final todas = await _repository.getAllEmotions();
      final Map<DateTime, List<Emotion>> nuevoMapa = {};

      for (var emo in todas) {
        // Parseamos la fecha y la normalizamos (año, mes, día solamente)
        // para que TableCalendar pueda compararlas correctamente.
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
      // Formateamos la fecha a 'YYYY-MM-DD' para el repositorio
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

  // --- Métodos de Escritura ---

  /// Guarda una nueva emoción y actualiza el estado global
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

      // Limpiamos el campo de texto
      notaController.clear();

      // IMPORTANTE: Refrescamos el mapa del calendario para que aparezca el nuevo punto
      await cargarTodosLosEventos();
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
}

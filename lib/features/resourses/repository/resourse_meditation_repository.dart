import 'package:bloomind/features/resourses/model/meditation.dart';

abstract class ResourseMeditationRepository {
  // Crear una nueva frase
  Future<int> createMeditation(ResourseMeditation resourse_meditation);

  // Obtener todas las meditaciones disponibles
  Future<List<ResourseMeditation>> getAllMeditations();

  // Editar una Frase (id_frases)
  Future<int> updateMeditation(ResourseMeditation resourse_meditation);

  // Eliminar frase de la biblioteca
  Future<int> deleteMeditation(int id_meditacion);

  // Obtener frases de acuerdo al (id_frases)
  Future<List<ResourseMeditation>> getMeditationById(int id_meditacion);
}

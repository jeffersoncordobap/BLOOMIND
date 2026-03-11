import '../model/resourse.dart';

abstract class ResourseRepository {
  // Crear una nueva frase
  Future<int> createFrases(ResourseFrases resourse_frases);

  // Obtener todas las frases disponibles
  Future<List<ResourseFrases>> getAllFrases();

  // Editar una Frase (id_frases)
  Future<int> updateFrase(ResourseFrases resourse_frases);

  // Eliminar frase de la biblioteca
  Future<int> deleteFrase(int id_frases);

  // Obtener frases de acuerdo al (id_frases)
  Future<List<ResourseFrases>> getFrasesById(int id_frases);

}
import 'package:bloomind/features/resourses/model/support_line.dart';

abstract class SupportLineRepository {
  /// Obtiene todos los contactos de las líneas de apoyo
  Future<List<SupportLine>> getAllSupportLines();

  /// Inserta un nuevo contacto en la base de datos
  Future<int> insertSupportLine(SupportLine line);

  /// Actualiza si un contacto es favorito o no
  Future<int> updateFavoriteStatus(int id, bool isFavorite);

  /// Elimina un contacto por su ID
  Future<int> deleteSupportLine(int id);

  /// Actualiza un contacto existente
  Future<int> updateSupportLine(SupportLine line);
}

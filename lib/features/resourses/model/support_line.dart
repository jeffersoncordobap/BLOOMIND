import 'package:bloomind/core/database/database_config.dart';

class SupportLine {
  final int? idContact;
  final String name;
  final String phone;
  final String? description;
  final bool isFavorite;
  final int state;

  SupportLine({
    this.idContact,
    required this.name,
    required this.phone,
    this.description,
    this.isFavorite = false,
    this.state = 1,
  });

  // Convertir de Objeto a Map (para insertar en la DB)
  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.colContactId: idContact,
      DatabaseConfig.colContactName: name,
      DatabaseConfig.colContactPhone: phone,
      DatabaseConfig.colContactDescription: description,
      DatabaseConfig.colIsFavoriteContact: isFavorite ? 1 : 0,
      DatabaseConfig.colContactState: state,
    };
  }

  // Convertir de Map a Objeto (para leer de la DB)
  factory SupportLine.fromMap(Map<String, dynamic> map) {
    return SupportLine(
      idContact: map[DatabaseConfig.colContactId],
      name: map[DatabaseConfig.colContactName],
      phone: map[DatabaseConfig.colContactPhone],
      description: map[DatabaseConfig.colContactDescription],
      isFavorite: map[DatabaseConfig.colIsFavoriteContact] == 1,
      state: map[DatabaseConfig.colContactState] ?? 1,
    );
  }
}

import '../../../core/database/database_config.dart';

class ResourseFrases {
  final int? id_frases;
  final String contenido_frases;
  final bool favorita_frase;

  ResourseFrases({
    this.id_frases,
    required this.contenido_frases,
    required this.favorita_frase
  });


  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.recFrasesId: id_frases,
      DatabaseConfig.recFrasesContenido: contenido_frases,
      DatabaseConfig.recFrasesFavorite: favorita_frase ? 1 : 0,
    };
  }

  factory ResourseFrases.fromMap(Map<String, dynamic> map) {
    return ResourseFrases(
      id_frases: map[DatabaseConfig.recFrasesId],
      contenido_frases: map[DatabaseConfig.recFrasesContenido],
      favorita_frase: map[DatabaseConfig.recFrasesFavorite] == 1,
    );
  }

}
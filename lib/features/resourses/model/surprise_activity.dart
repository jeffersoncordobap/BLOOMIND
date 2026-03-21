import 'package:bloomind/core/database/database_config.dart';

class SurpriseActivity {
  final int? id;
  final String description;
  final bool isFavorite;
  final DateTime? deletedAt;

  SurpriseActivity({
    this.id,
    required this.description,
    this.isFavorite = false,
    this.deletedAt,
  });

  bool get estaEnPapelera => deletedAt != null;

  int get diasRestantes {
    if (deletedAt == null) return 7;
    final diff = 7 - DateTime.now().difference(deletedAt!).inDays;
    return diff < 0 ? 0 : diff;
  }

  Map<String, dynamic> toMap() => {
        DatabaseConfig.colSurpriseActivityDescription: description,
        DatabaseConfig.colSurpriseActivityFavorite: isFavorite ? 1 : 0,
        DatabaseConfig.colSurpriseActivityDeletedAt: deletedAt?.toIso8601String(),
      };

  factory SurpriseActivity.fromMap(Map<String, dynamic> map) => SurpriseActivity(
        id: map[DatabaseConfig.colSurpriseActivityId],
        description: map[DatabaseConfig.colSurpriseActivityDescription],
        isFavorite: map[DatabaseConfig.colSurpriseActivityFavorite] == 1,
        deletedAt: map[DatabaseConfig.colSurpriseActivityDeletedAt] != null
            ? DateTime.parse(map[DatabaseConfig.colSurpriseActivityDeletedAt])
            : null,
      );
}

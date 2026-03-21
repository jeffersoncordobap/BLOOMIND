import 'package:bloomind/core/database/database_config.dart';

class SurpriseActivity {
  final int? id;
  final String description;
  final bool isFavorite;

  SurpriseActivity({
    this.id,
    required this.description,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() => {
        DatabaseConfig.colSurpriseActivityDescription: description,
        DatabaseConfig.colSurpriseActivityFavorite: isFavorite ? 1 : 0,
      };

  factory SurpriseActivity.fromMap(Map<String, dynamic> map) => SurpriseActivity(
        id: map[DatabaseConfig.colSurpriseActivityId],
        description: map[DatabaseConfig.colSurpriseActivityDescription],
        isFavorite: map[DatabaseConfig.colSurpriseActivityFavorite] == 1,
      );
}

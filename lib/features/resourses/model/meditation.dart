import '../../../core/database/database_config.dart';

class ResourseMeditation {
  final int? id_meditacion;
  final String title_meditation;
  final String descripcion_meditation; 
  final int? duration_meditation;
  final String filepath_meditation;
  final bool favorite_meditation;

  const ResourseMeditation({
    this.id_meditacion,
    required this.title_meditation,
    required this.descripcion_meditation,
    required this.duration_meditation,
    required this.filepath_meditation,
    this.favorite_meditation = false
  });


  Map<String, dynamic> toMap() {
  return {
    DatabaseConfig.recMeditationId: id_meditacion,
    DatabaseConfig.recMeditationTitle: title_meditation,
    DatabaseConfig.recMeditationDescrip: descripcion_meditation,
    DatabaseConfig.recMeditationDurat: duration_meditation,
    DatabaseConfig.recMeditationFilepath: filepath_meditation,
    DatabaseConfig.recMeditationFavorite: favorite_meditation ? 1 : 0,
  };
}

factory ResourseMeditation.fromMap(Map<String, dynamic> map) {
  return ResourseMeditation(
    id_meditacion: map[DatabaseConfig.recMeditationId] is int
        ? map[DatabaseConfig.recMeditationId] as int
        : int.tryParse(map[DatabaseConfig.recMeditationId].toString()),
    title_meditation: map[DatabaseConfig.recMeditationTitle].toString(),
    descripcion_meditation: map[DatabaseConfig.recMeditationDescrip].toString(),
    duration_meditation: map[DatabaseConfig.recMeditationDurat] is int
        ? map[DatabaseConfig.recMeditationDurat] as int
        : int.tryParse(map[DatabaseConfig.recMeditationDurat].toString()),
    filepath_meditation: map[DatabaseConfig.recMeditationFilepath].toString(),
    favorite_meditation: (map[DatabaseConfig.recMeditationFavorite] is int
            ? map[DatabaseConfig.recMeditationFavorite] == 1
            : map[DatabaseConfig.recMeditationFavorite].toString() == '1'),
  );
}


}


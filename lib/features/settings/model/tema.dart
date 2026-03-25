import 'package:bloomind/core/database/database_config.dart';

class ConfigTemas {
  final bool bool_tema;

  ConfigTemas({required this.bool_tema});

  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.segTemasBoleano: bool_tema ? 1 : 0,
    };
  }

  factory ConfigTemas.fromMap(Map<String, dynamic> map) {
    return ConfigTemas(
      bool_tema: map[DatabaseConfig.segTemasBoleano] == 1,
    );
  }
}
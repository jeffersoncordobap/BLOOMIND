import 'package:bloomind/core/database/database_config.dart';
import 'package:bloomind/core/database/database_helper.dart';
import 'package:bloomind/features/settings/model/tema.dart';
import 'package:bloomind/features/settings/repository/settings_tema_repository.dart';

class ConfigTemasRepositoryImpl implements ConfigTemasRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<void> saveTema(ConfigTemas tema) async {
    final db = await _dbHelper.database;

    // Si ya hay un registro, actualiza; si no, inserta
    final List<Map<String, dynamic>> existing =
        await db.query(DatabaseConfig.tableTemas);

    if (existing.isEmpty) {
      await db.insert(DatabaseConfig.tableTemas, tema.toMap());
    } else {
      await db.update(
        DatabaseConfig.tableTemas,
        tema.toMap(),
      );
    }
  }

  @override
  Future<ConfigTemas?> getTema() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseConfig.tableTemas);

    if (maps.isNotEmpty) {
      return ConfigTemas.fromMap(maps.first);
    }
    return null; // aún no hay registro
  }
}
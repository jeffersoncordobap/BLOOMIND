import 'package:bloomind/core/database/database_config.dart';
import 'package:bloomind/core/database/database_helper.dart';
import 'package:bloomind/features/resourses/model/surprise_activity.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository.dart';

class SurpriseActivityRepositoryImpl implements SurpriseActivityRepository {
  final DatabaseHelper _db = DatabaseHelper();

  @override
  Future<List<SurpriseActivity>> getAll() async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseConfig.tableSurpriseActivities,
      where: '${DatabaseConfig.colSurpriseActivityDeletedAt} IS NULL',
    );
    return rows.map((r) => SurpriseActivity.fromMap(r)).toList();
  }

  @override
  Future<void> insert(SurpriseActivity activity) async {
    final db = await _db.database;
    await db.insert(DatabaseConfig.tableSurpriseActivities, activity.toMap());
  }

  @override
  Future<int> count() async {
    final db = await _db.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as c FROM ${DatabaseConfig.tableSurpriseActivities} WHERE ${DatabaseConfig.colSurpriseActivityDeletedAt} IS NULL');
    return result.first['c'] as int;
  }

  @override
  Future<void> toggleFavorito(int id, bool isFavorite) async {
    final db = await _db.database;
    await db.update(
      DatabaseConfig.tableSurpriseActivities,
      {DatabaseConfig.colSurpriseActivityFavorite: isFavorite ? 1 : 0},
      where: '${DatabaseConfig.colSurpriseActivityId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<SurpriseActivity>> getFavoritos() async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseConfig.tableSurpriseActivities,
      where:
          '${DatabaseConfig.colSurpriseActivityFavorite} = 1 AND ${DatabaseConfig.colSurpriseActivityDeletedAt} IS NULL',
    );
    return rows.map((r) => SurpriseActivity.fromMap(r)).toList();
  }

  @override
  Future<int> countFavoritos() async {
    final db = await _db.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as c FROM ${DatabaseConfig.tableSurpriseActivities} WHERE ${DatabaseConfig.colSurpriseActivityFavorite} = 1 AND ${DatabaseConfig.colSurpriseActivityDeletedAt} IS NULL');
    return result.first['c'] as int;
  }

  @override
  Future<void> moverAPapelera(int id) async {
    final db = await _db.database;
    await db.update(
      DatabaseConfig.tableSurpriseActivities,
      {
        DatabaseConfig.colSurpriseActivityFavorite: 0,
        DatabaseConfig.colSurpriseActivityDeletedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConfig.colSurpriseActivityId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<SurpriseActivity>> getPapelera() async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseConfig.tableSurpriseActivities,
      where: '${DatabaseConfig.colSurpriseActivityDeletedAt} IS NOT NULL',
    );
    return rows.map((r) => SurpriseActivity.fromMap(r)).toList();
  }

  @override
  Future<void> restaurarDePapelera(int id) async {
    final db = await _db.database;
    await db.update(
      DatabaseConfig.tableSurpriseActivities,
      {
        DatabaseConfig.colSurpriseActivityFavorite: 1,
        DatabaseConfig.colSurpriseActivityDeletedAt: null,
      },
      where: '${DatabaseConfig.colSurpriseActivityId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> eliminarPermanentemente(int id) async {
    final db = await _db.database;
    await db.update(
      DatabaseConfig.tableSurpriseActivities,
      {
        DatabaseConfig.colSurpriseActivityFavorite: 0,
        DatabaseConfig.colSurpriseActivityDeletedAt: null,
      },
      where: '${DatabaseConfig.colSurpriseActivityId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> limpiarPapeleraExpirada() async {
    final db = await _db.database;
    final limite = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    await db.update(
      DatabaseConfig.tableSurpriseActivities,
      {
        DatabaseConfig.colSurpriseActivityFavorite: 0,
        DatabaseConfig.colSurpriseActivityDeletedAt: null,
      },
      where: '${DatabaseConfig.colSurpriseActivityDeletedAt} IS NOT NULL AND ${DatabaseConfig.colSurpriseActivityDeletedAt} < ?',
      whereArgs: [limite],
    );
  }
}

import 'package:bloomind/core/database/database_config.dart';
import 'package:bloomind/core/database/database_helper.dart';
import 'package:bloomind/features/resourses/model/surprise_activity.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository.dart';

class SurpriseActivityRepositoryImpl implements SurpriseActivityRepository {
  final DatabaseHelper _db = DatabaseHelper();

  @override
  Future<List<SurpriseActivity>> getAll() async {
    final db = await _db.database;
    final rows = await db.query(DatabaseConfig.tableSurpriseActivities);
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
        'SELECT COUNT(*) as c FROM ${DatabaseConfig.tableSurpriseActivities}');
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
      where: '${DatabaseConfig.colSurpriseActivityFavorite} = 1',
    );
    return rows.map((r) => SurpriseActivity.fromMap(r)).toList();
  }

  @override
  Future<int> countFavoritos() async {
    final db = await _db.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as c FROM ${DatabaseConfig.tableSurpriseActivities} WHERE ${DatabaseConfig.colSurpriseActivityFavorite} = 1');
    return result.first['c'] as int;
  }
}

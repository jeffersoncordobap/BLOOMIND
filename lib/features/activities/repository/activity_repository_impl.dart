import '../../../core/database/database_config.dart';
import '../../../core/database/database_helper.dart';
import '../model/activity.dart';
import 'activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<int> createActivity(Activity activity) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseConfig.tableActivity, activity.toMap());
  }

  @override
  Future<List<Activity>> getAllActivities() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableActivity,
      orderBy: '${DatabaseConfig.colActivityName} ASC',
    );
    return maps.map((map) => Activity.fromMap(map)).toList();
  }

  @override
  Future<int> updateActivity(Activity activity) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConfig.tableActivity,
      activity.toMap(),
      where: '${DatabaseConfig.colActivityId} = ?',
      whereArgs: [activity.idActivity],
    );
  }

  @override
  Future<int> deleteActivity(int idActivity) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConfig.tableActivity,
      where: '${DatabaseConfig.colActivityId} = ?',
      whereArgs: [idActivity],
    );
  }

  @override
  Future<List<Activity>> getActivitiesByCategory(String category) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableActivity,
      where: '${DatabaseConfig.colActivityCategory} = ?',
      whereArgs: [category],
    );
    return maps.map((map) => Activity.fromMap(map)).toList();
  }

  @override
  Future<List<Activity>> getActivitiesByRoutine(int idRoutine) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
      SELECT a.*, ra.hour 
      FROM ${DatabaseConfig.tableActivity} a
      INNER JOIN ${DatabaseConfig.tableRoutineActivity} ra 
      ON a.${DatabaseConfig.colActivityId} = ra.${DatabaseConfig.colActivityId}
      WHERE ra.${DatabaseConfig.colRoutineId} = ?
    ''',
      [idRoutine],
    );

    return results.map((map) => Activity.fromMap(map)).toList();
  }

  @override
  Future<void> linkActivityToRoutine(
    int idRoutine,
    int idActivity,
    String hour,
  ) async {
    final db = await _dbHelper.database;
    await db.insert(DatabaseConfig.tableRoutineActivity, {
      DatabaseConfig.colRoutineId: idRoutine,
      DatabaseConfig.colActivityId: idActivity,
      DatabaseConfig.colRoutineActivityHour: hour,
    });
  }

  Future<void> updateActivityFull(
    Activity activity,
    int idRoutine,
    String oldHour,
  ) async {
    final db = await _dbHelper.database;

    // 1. Actualizar datos globales de la actividad (Nombre, Categoria, Emoji)
    await db.update(
      DatabaseConfig.tableActivity,
      {
        DatabaseConfig.colActivityName: activity.name,
        DatabaseConfig.colActivityCategory: activity.category,
        DatabaseConfig.colActivityEmoji: activity.emoji,
      },
      where: '${DatabaseConfig.colActivityId} = ?',
      whereArgs: [activity.idActivity],
    );

    // 2. Actualizar la HORA en la tabla intermedia
    await db.update(
      DatabaseConfig.tableRoutineActivity,
      {DatabaseConfig.colRoutineActivityHour: activity.hour},
      where:
          '${DatabaseConfig.colRoutineId} = ? AND ${DatabaseConfig.colActivityId} = ? AND ${DatabaseConfig.colRoutineActivityHour} = ?',
      whereArgs: [idRoutine, activity.idActivity, oldHour],
    );
  }
}

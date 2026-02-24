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
}

import '../../../core/database/database_config.dart';
import '../../../core/database/database_helper.dart';
import '../model/routine.dart';
import '../../activities/model/activity.dart';
import 'routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<int> createRoutine(Routine routine) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> existing = await db.query(
      DatabaseConfig.tableRoutine,
      where: 'LOWER(${DatabaseConfig.colRoutineName}) = ?',
      whereArgs: [routine.name.toLowerCase()],
    );

    if (existing.isNotEmpty) {
      return -1;
    }
    return await db.insert(DatabaseConfig.tableRoutine, routine.toMap());
  }

  @override
  Future<List<Routine>> getAllRoutines() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableRoutine,
    );
    return maps.map((map) => Routine.fromMap(map)).toList();
  }

  @override
  Future<void> addActivityToRoutine(int idRoutine, int idActivity) async {
    final db = await _dbHelper.database;
    await db.insert(DatabaseConfig.tableRoutineActivity, {
      DatabaseConfig.colRoutineId: idRoutine,
      DatabaseConfig.colActivityId: idActivity,
    });
  }

  @override
  Future<List<Activity>> getActivitiesByRoutine(int idRoutine) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> res = await db.rawQuery(
      '''
      SELECT a.*, ra.${DatabaseConfig.colRoutineActivityHour} as hour
      FROM ${DatabaseConfig.tableActivity} a
      INNER JOIN ${DatabaseConfig.tableRoutineActivity} ra 
      ON a.${DatabaseConfig.colActivityId} = ra.${DatabaseConfig.colActivityId}
      WHERE ra.${DatabaseConfig.colRoutineId} = ? AND a.${DatabaseConfig.colActivityState} = 1
      ORDER BY ra.${DatabaseConfig.colRoutineActivityHour} ASC
    ''',
      [idRoutine],
    );

    return res.map((map) => Activity.fromMap(map)).toList();
  }

  @override
  Future<int> deleteRoutine(int idRoutine) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConfig.tableRoutine,
      where: '${DatabaseConfig.colRoutineId} = ?',
      whereArgs: [idRoutine],
    );
  }
}

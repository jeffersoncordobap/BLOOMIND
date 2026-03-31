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
      where: '${DatabaseConfig.colRoutineState} = ?',
      whereArgs: [1], // Solo mostrar activas
      orderBy: '${DatabaseConfig.colRoutineName} ASC',
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
    ''',
      [idRoutine],
    );

    final activities = res.map((map) => Activity.fromMap(map)).toList();

    // Ordenar actividades por hora cronológicamente
    activities.sort((a, b) => _compareTimeStrings(a.hour, b.hour));

    return activities;
  }

  /// Compara dos strings de hora (ej: "08:00 AM") para ordenarlos cronológicamente
  int _compareTimeStrings(String timeA, String timeB) {
    List<int>? parse(String s) {
      try {
        final parts = s.trim().split(' ');
        if (parts.length != 2) return null;

        final timeParts = parts[0].split(':');
        if (timeParts.length != 2) return null;

        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);
        final period = parts[1].toUpperCase();

        if (period == 'PM' && hour != 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;

        return [hour, minute];
      } catch (e) {
        return null;
      }
    }

    final a = parse(timeA);
    final b = parse(timeB);

    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;

    if (a[0] != b[0]) return a[0].compareTo(b[0]);
    return a[1].compareTo(b[1]);
  }

  @override
  Future<int> deleteRoutine(int idRoutine) async {
    final db = await _dbHelper.database;

    // Soft Delete: Actualizamos el estado a 0 en lugar de borrar
    return await db.update(
      DatabaseConfig.tableRoutine,
      {DatabaseConfig.colRoutineState: 0},
      where: '${DatabaseConfig.colRoutineId} = ?',
      whereArgs: [idRoutine],
    );
  }

  @override
  Future<List<Routine>> getDeletedRoutines() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableRoutine,
      where: '${DatabaseConfig.colRoutineState} = ?',
      whereArgs: [0], // Solo eliminados (papelera)
      //orderBy: '${DatabaseConfig.colActivityDateTime} DESC',
    );
    return maps.map((map) => Routine.fromMap(map)).toList();
  }

  @override
  Future<int> restoreRoutine(int idRoutine) async {
    final db = await _dbHelper.database;

    return await db.update(
      DatabaseConfig.tableRoutine,
      {DatabaseConfig.colRoutineState: 1}, // Restaurar a activo
      where: '${DatabaseConfig.colRoutineId} = ?',
      whereArgs: [idRoutine],
    );
  }

  @override
  Future<int> forceDeleteRoutine(int idRoutine) async {
    final db = await _dbHelper.database;

    return await db.delete(
      DatabaseConfig.tableRoutine,
      where: '${DatabaseConfig.colRoutineId} = ?',
      whereArgs: [idRoutine],
    );
  }
}

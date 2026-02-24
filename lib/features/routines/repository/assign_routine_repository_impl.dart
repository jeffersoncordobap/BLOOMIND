import '../../../core/database/database_config.dart';
import '../../../core/database/database_helper.dart';
import '../model/assing_routine.dart';
import 'assign_routine_repository.dart';

class AssignRoutineRepositoryImpl implements AssignRoutineRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<int> assignRoutineToDate(AssignRoutine assignment) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseConfig.tableAssignRoutine,
      assignment.toMap(),
    );
  }

  @override
  Future<List<AssignRoutine>> getAssignmentsByDate(String date) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableAssignRoutine,
      where: '${DatabaseConfig.colAssignDateTime} LIKE ?',
      whereArgs: ['$date%'],
    );
    return maps.map((map) => AssignRoutine.fromMap(map)).toList();
  }

  @override
  Future<int> removeAssignment(int idAssign) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConfig.tableAssignRoutine,
      where: '${DatabaseConfig.colAssignId} = ?',
      whereArgs: [idAssign],
    );
  }
}

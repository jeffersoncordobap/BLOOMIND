import '../../../core/database/database_config.dart';
import '../../../core/database/database_helper.dart';
import '../model/resourse.dart';
import 'resourse_repository.dart';

class ResourseRepositoryImpl implements ResourseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<int> createFrases(ResourseFrases resourse_frases) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseConfig.tableFrasesFavorits, resourse_frases.toMap());
  }

  @override
  Future<List<ResourseFrases>> getAllFrases() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableFrasesFavorits,
      orderBy: '${DatabaseConfig.recFrasesContenido} ASC',
    );
    return maps.map((map) => ResourseFrases.fromMap(map)).toList();
  }

  @override
  Future<int> updateFrase(ResourseFrases resourse_frases) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConfig.tableFrasesFavorits,
      resourse_frases.toMap(),
      where: '${DatabaseConfig.recFrasesId} = ?',
      whereArgs: [resourse_frases.id_frases],
    );
  }

  @override
  Future<int> deleteFrase(int id_frases) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConfig.tableFrasesFavorits,
      where: '${DatabaseConfig.recFrasesId} = ?',
      whereArgs: [id_frases],
    );
  }

  @override
  Future<List<ResourseFrases>> getFrasesById(int id_frases) async {

    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableFrasesFavorits,
      where: '${DatabaseConfig.recFrasesId} = ?',
      whereArgs: [id_frases],
    );

    return maps.map((map) => ResourseFrases.fromMap(map)).toList();
  }

}
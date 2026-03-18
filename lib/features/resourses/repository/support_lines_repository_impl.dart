import 'package:sqflite/sqflite.dart';
import 'package:bloomind/core/database/database_config.dart';
import 'package:bloomind/core/database/database_helper.dart'; // Importante
import 'package:bloomind/features/resourses/model/support_line.dart';
import 'package:bloomind/features/resourses/repository/support_lines_repository.dart';

class SupportLineRepositoryImpl implements SupportLineRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<List<SupportLine>> getAllSupportLines() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableSupportLines,
    );
    return List.generate(maps.length, (i) => SupportLine.fromMap(maps[i]));
  }

  @override
  Future<int> insertSupportLine(SupportLine line) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseConfig.tableSupportLines,
      line.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> updateFavoriteStatus(int id, bool isFavorite) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConfig.tableSupportLines,
      {DatabaseConfig.colIsFavoriteContact: isFavorite ? 1 : 0},
      where: '${DatabaseConfig.colContactId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteSupportLine(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConfig.tableSupportLines,
      where: '${DatabaseConfig.colContactId} = ?',
      whereArgs: [id],
    );
  }
}

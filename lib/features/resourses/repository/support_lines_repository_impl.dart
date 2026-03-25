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
      where: '${DatabaseConfig.colContactState} = ?',
      whereArgs: [1], // Solo mostrar activos
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
  Future<int> updateSupportLine(SupportLine line) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConfig.tableSupportLines,
      line.toMap(),
      where: '${DatabaseConfig.colContactId} = ?',
      whereArgs: [line.idContact],
    );
  }

  @override
  Future<List<SupportLine>> getFavoriteSupportLines() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableSupportLines,
      where:
          '${DatabaseConfig.colIsFavoriteContact} = ? AND ${DatabaseConfig.colContactState} = ?',
      whereArgs: [1, 1], // Favoritos Y Activos
    );
    return List.generate(maps.length, (i) => SupportLine.fromMap(maps[i]));
  }

  @override
  Future<int> deleteSupportLine(int idSupportLine) async {
    final db = await _dbHelper.database;

    // Soft Delete: Actualizamos el estado a 0 en lugar de borrar
    return await db.update(
      DatabaseConfig.tableSupportLines,
      {DatabaseConfig.colContactState: 0},
      where: '${DatabaseConfig.colContactId} = ?',
      whereArgs: [idSupportLine],
    );
  }

  @override
  Future<List<SupportLine>> getDeletedSupportLines() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableSupportLines,
      where: '${DatabaseConfig.colContactState} = ?',
      whereArgs: [0], // Solo eliminados (papelera)
      //orderBy: '${DatabaseConfig.colActivityDateTime} DESC',
    );
    return maps.map((map) => SupportLine.fromMap(map)).toList();
  }

  @override
  Future<int> restoreSupportLine(int idSupportLine) async {
    final db = await _dbHelper.database;

    return await db.update(
      DatabaseConfig.tableSupportLines,
      {DatabaseConfig.colContactState: 1}, // Restaurar a activo
      where: '${DatabaseConfig.colContactId} = ?',
      whereArgs: [idSupportLine],
    );
  }

  @override
  Future<int> forceDeleteSupportLine(int idSupportLine) async {
    final db = await _dbHelper.database;

    return await db.delete(
      DatabaseConfig.tableSupportLines,
      where: '${DatabaseConfig.colContactId} = ?',
      whereArgs: [idSupportLine],
    );
  }
}

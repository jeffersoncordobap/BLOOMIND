import '../../../core/database/database_config.dart';
import '../../../core/database/database_helper.dart';
import '../model/emotion.dart';
import 'emotion_repository.dart';

class EmotionRepositoryImpl implements EmotionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<int> addEmotion(Emotion emotion) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseConfig.tableEmotion, emotion.toMap());
  }

  @override
  Future<List<Emotion>> getAllEmotions() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableEmotion,
      where: '${DatabaseConfig.colEmotionState} = ?',
      whereArgs: [1], // Solo activos
      orderBy: '${DatabaseConfig.colEmotionDateTime} DESC',
    );
    return maps.map((map) => Emotion.fromMap(map)).toList();
  }

  @override
  Future<int> updateEmotion(Emotion emotion) async {
    final db = await _dbHelper.database;

    return await db.update(
      DatabaseConfig.tableEmotion,
      emotion.toMap(),
      where: '${DatabaseConfig.colEmotionId} = ?',
      whereArgs: [emotion.idEmotion],
    );
  }

  @override
  Future<int> deleteEmotion(int idEmotion) async {
    final db = await _dbHelper.database;

    // Soft Delete: Actualizamos el estado a 0 en lugar de borrar
    return await db.update(
      DatabaseConfig.tableEmotion,
      {DatabaseConfig.colEmotionState: 0},
      where: '${DatabaseConfig.colEmotionId} = ?',
      whereArgs: [idEmotion],
    );
  }

  @override
  Future<List<Emotion>> getEmotionsByDate(String date) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableEmotion,
      where:
          '${DatabaseConfig.colEmotionDateTime} LIKE ? AND ${DatabaseConfig.colEmotionState} = ?',
      whereArgs: ['$date%', 1], // Solo activos
      orderBy: '${DatabaseConfig.colEmotionDateTime} ASC',
    );

    return maps.map((map) => Emotion.fromMap(map)).toList();
  }

  @override
  Future<List<Emotion>> getDeletedEmotions() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableEmotion,
      where: '${DatabaseConfig.colEmotionState} = ?',
      whereArgs: [0], // Solo eliminados (papelera)
      orderBy: '${DatabaseConfig.colEmotionDateTime} DESC',
    );
    return maps.map((map) => Emotion.fromMap(map)).toList();
  }

  @override
  Future<int> restoreEmotion(int idEmotion) async {
    final db = await _dbHelper.database;

    return await db.update(
      DatabaseConfig.tableEmotion,
      {DatabaseConfig.colEmotionState: 1}, // Restaurar a activo
      where: '${DatabaseConfig.colEmotionId} = ?',
      whereArgs: [idEmotion],
    );
  }

  @override
  Future<int> forceDeleteEmotion(int idEmotion) async {
    final db = await _dbHelper.database;

    return await db.delete(
      DatabaseConfig.tableEmotion,
      where: '${DatabaseConfig.colEmotionId} = ?',
      whereArgs: [idEmotion],
    );
  }
}

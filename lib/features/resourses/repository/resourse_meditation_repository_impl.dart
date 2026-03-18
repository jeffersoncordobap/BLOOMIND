import '../../../core/database/database_config.dart';
import '../../../core/database/database_helper.dart';
import 'resourse_meditation_repository.dart';
import '../model/meditation.dart';

class ResourseMeditationRepositoryImpl implements ResourseMeditationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<int> createMeditation(ResourseMeditation meditation) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseConfig.tableAudiosMeditacion,
      meditation.toMap(),
    );
  }

  @override
  Future<List<ResourseMeditation>> getAllMeditations() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableAudiosMeditacion,
      orderBy: '${DatabaseConfig.recMeditationTitle} ASC',
    );

    return maps.map((map) => ResourseMeditation.fromMap(map)).toList();
  }

  @override
  Future<int> updateMeditation(ResourseMeditation meditation) async {
    final db = await _dbHelper.database;

    return await db.update(
      DatabaseConfig.tableAudiosMeditacion,
      meditation.toMap(),
      where: '${DatabaseConfig.recMeditationId} = ?',
      whereArgs: [meditation.id_meditacion],
    );
  }

  @override
  Future<int> deleteMeditation(int id_meditacion) async {
    final db = await _dbHelper.database;

    return await db.delete(
      DatabaseConfig.tableAudiosMeditacion,
      where: '${DatabaseConfig.recMeditationId} = ?',
      whereArgs: [id_meditacion],
    );
  }

  @override
  Future<List<ResourseMeditation>> getMeditationById(int id_meditacion) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConfig.tableAudiosMeditacion,
      where: '${DatabaseConfig.recMeditationId} = ?',
      whereArgs: [id_meditacion],
    );

    return maps.map((map) => ResourseMeditation.fromMap(map)).toList();
  }
}
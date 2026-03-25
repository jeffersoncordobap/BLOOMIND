import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/database/database_config.dart';
import '../model/relaxing_audio_model.dart';
import 'relaxing_audio_repository.dart';

class RelaxingAudioRepositoryImpl implements RelaxingAudioRepository {
  final DatabaseHelper _databaseHelper;

  RelaxingAudioRepositoryImpl(this._databaseHelper);

  Future<Database> get _db async => await _databaseHelper.database;

  @override
  Future<List<RelaxingAudioModel>> getAllAudios() async {
    final db = await _db;

    final result = await db.query(
      DatabaseConfig.tableRelaxingAudios,
      orderBy: '${DatabaseConfig.recRelaxingAudioCreatedAt} DESC',
    );

    return result.map((map) => RelaxingAudioModel.fromMap(map)).toList();
  }

  @override
  Future<List<RelaxingAudioModel>> getFavoriteAudios() async {
    final db = await _db;

    final result = await db.query(
      DatabaseConfig.tableRelaxingAudios,
      where: '${DatabaseConfig.recRelaxingAudioIsFavorite} = ?',
      whereArgs: [1],
      orderBy: '${DatabaseConfig.recRelaxingAudioCreatedAt} DESC',
    );

    return result.map((map) => RelaxingAudioModel.fromMap(map)).toList();
  }

  @override
  Future<int> insertAudio(RelaxingAudioModel audio) async {
    final db = await _db;

    return await db.insert(
      DatabaseConfig.tableRelaxingAudios,
      audio.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> updateAudio(RelaxingAudioModel audio) async {
    final db = await _db;

    return await db.update(
      DatabaseConfig.tableRelaxingAudios,
      audio.toMap(),
      where: '${DatabaseConfig.recRelaxingAudioId} = ?',
      whereArgs: [audio.id],
    );
  }

  @override
  Future<int> updateFavorite({
    required int audioId,
    required bool isFavorite,
  }) async {
    final db = await _db;

    return await db.update(
      DatabaseConfig.tableRelaxingAudios,
      {
        DatabaseConfig.recRelaxingAudioIsFavorite: isFavorite ? 1 : 0,
      },
      where: '${DatabaseConfig.recRelaxingAudioId} = ?',
      whereArgs: [audioId],
    );
  }

  @override
  Future<int> deleteAudio(int audioId) async {
    final db = await _db;

    return await db.delete(
      DatabaseConfig.tableRelaxingAudios,
      where: '${DatabaseConfig.recRelaxingAudioId} = ?',
      whereArgs: [audioId],
    );
  }
}
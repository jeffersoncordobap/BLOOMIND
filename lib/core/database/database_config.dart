class DatabaseConfig {
  // Configuración general
  static const String dbName = 'bloomind.db';
  static const int dbVersion = 1;

  // TABLA EMOTION
  static const String tableEmotion = 'emotion';
  static const String colEmotionId = 'id_emotion';
  static const String colEmotionMoodLevel = 'mood_level';
  static const String colEmotionLabel = 'label';
  static const String colEmotionNote = 'note';
  static const String colEmotionDateTime = 'date_time';

  // TABLA ACTIVITY
  static const String tableActivity = 'activity';
  static const String colActivityId = 'id_activity';
  static const String colActivityCategory = 'category';
  static const String colActivityName = 'name';
  static const String colActivityEmoji = 'emoji';

  // TABLA ROUTINE
  static const String tableRoutine = 'routine';
  static const String colRoutineId = 'id_routine';
  static const String colRoutineName = 'name';

  // TABLA INTERMEDIA: ROUTINE_ACTIVITY
  static const String tableRoutineActivity = 'routine_activity';
  static const String colRoutineActivityHour = 'hour';

  // TABLA ASSIGN_ROUTINE
  static const String tableAssignRoutine = 'assign_routine';
  static const String colAssignId = 'id_assign_routine';
  static const String colAssignDateTime = 'date_time';







  // TABLA RECURSES_FRASES_FAVORITE
  static const String tableFrasesFavorits = "Frases_bool_favorite";
  static const String recFrasesId = "id_frases";
  static const String recFrasesContenido = "contenido_frases";
  static const String recFrasesFavorite = "favorita_frase";


  // =============================
// RELAXING AUDIOS TABLE
// =============================
  static const String tableRelaxingAudios = 'relaxing_audios';
  static const String recRelaxingAudioId = 'id';
  static const String recRelaxingAudioTitle = 'title';
  static const String recRelaxingAudioDurationSeconds = 'duration_seconds';
  static const String recRelaxingAudioFilePath = 'file_path';
  static const String recRelaxingAudioFileName = 'file_name';
  static const String recRelaxingAudioFileSize = 'file_size';
  static const String recRelaxingAudioIsFavorite = 'is_favorite';
  static const String recRelaxingAudioCreatedAt = 'created_at';
  static const String recRelaxingAudioIsAsset = 'is_asset';
}

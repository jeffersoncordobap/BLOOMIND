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
  static const String colEmotionState = 'state';

  // TABLA ACTIVITY
  static const String tableActivity = 'activity';
  static const String colActivityId = 'id_activity';
  static const String colActivityCategory = 'category';
  static const String colActivityName = 'name';
  static const String colActivityEmoji = 'emoji';
  static const String colActivityState = 'state';

  // TABLA ROUTINE
  static const String tableRoutine = 'routine';
  static const String colRoutineId = 'id_routine';
  static const String colRoutineName = 'name';
  static const String colRoutineState = 'state';

  // TABLA INTERMEDIA: ROUTINE_ACTIVITY
  static const String tableRoutineActivity = 'routine_activity';
  static const String colRoutineActivityHour = 'hour';

  // TABLA ASSIGN_ROUTINE
  static const String tableAssignRoutine = 'assign_routine';
  static const String colAssignId = 'id_assign_routine';
  static const String colAssignDateTime = 'date_time';

  // TABLA RECURSES__PHRASES
  static const String tableFrasesFavorits = 'Frases_bool_favorite';
  static const String recFrasesId = 'id_frases';
  static const String recFrasesContenido = 'contenido_frases';
  static const String recFrasesFavorite = 'favorita_frase';

  // TABLA RELAXING AUDIOS
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

  // TABLA RECURSES__SUPRISE_ACTIVITIES
  static const String tableSurpriseActivities = 'Surprise_Activities';
  static const String colSurpriseActivityId = 'id_surprise_activity';
  static const String colSurpriseActivityDescription =
      'description_surprise_activity';
  static const String colSurpriseActivityFavorite =
      'favorite_surprise_activity';

  // TABLA SUPPORT_LINES
  static const String tableSupportLines = 'Support_Lines';
  static const String colContactId = 'id_contact';
  static const String colContactName = 'contact_name';
  static const String colContactPhone = 'contact_phone';
  static const String colContactDescription = 'contact_description';
  static const String colIsFavoriteContact = 'is_favorite_contact';

  // TABLA DE MEDITACION
  static const String tableAudiosMeditacion = 'Meditation';
  static const String recMeditationId = 'id_meditacion';
  static const String recMeditationTitle = 'title_meditation';
  static const String recMeditationDescrip = 'descripcion_meditation';
  static const String recMeditationDurat = 'duration_meditation';
  static const String recMeditationFilepath = 'filepath_meditation';
  static const String recMeditationFavorite = 'favorite_meditation';
}

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
}

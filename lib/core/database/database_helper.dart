import 'package:bloomind/core/database/database_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'bloomind.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // 1. TABLA EMOCIONES
    await db.execute('''
    CREATE TABLE ${DatabaseConfig.tableEmotion} (
      ${DatabaseConfig.colEmotionId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.colEmotionMoodLevel} INTEGER,
      ${DatabaseConfig.colEmotionLabel} TEXT,
      ${DatabaseConfig.colEmotionNote} TEXT,
      ${DatabaseConfig.colEmotionDateTime} TEXT
    )
  ''');

    // 2. TABLA ACTIVIDADES
    await db.execute('''
    CREATE TABLE ${DatabaseConfig.tableActivity} (
      ${DatabaseConfig.colActivityId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.colActivityCategory} TEXT,
      ${DatabaseConfig.colActivityName} TEXT,
      ${DatabaseConfig.colActivityEmoji} TEXT
    )
  ''');

    // 3. TABLA RUTINAS
    await db.execute('''
    CREATE TABLE ${DatabaseConfig.tableRoutine} (
      ${DatabaseConfig.colRoutineId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.colRoutineName} TEXT
    )
  ''');

    // 4. TABLA INTERMEDIA ROUTINAS_ACTIVIDADES (Relación Muchos a Muchos)
    await db.execute('''
    CREATE TABLE ${DatabaseConfig.tableRoutineActivity} (
      ${DatabaseConfig.colRoutineId} INTEGER,
      ${DatabaseConfig.colActivityId} INTEGER,
      ${DatabaseConfig.colRoutineActivityHour} TEXT,
      PRIMARY KEY (${DatabaseConfig.colRoutineId}, ${DatabaseConfig.colActivityId}, ${DatabaseConfig.colRoutineActivityHour}),
      FOREIGN KEY (${DatabaseConfig.colRoutineId}) 
        REFERENCES ${DatabaseConfig.tableRoutine} (${DatabaseConfig.colRoutineId}) 
        ON DELETE CASCADE,
      FOREIGN KEY (${DatabaseConfig.colActivityId}) 
        REFERENCES ${DatabaseConfig.tableActivity} (${DatabaseConfig.colActivityId}) 
        ON DELETE CASCADE
    )
  ''');

    // 5. TABLA ASIGNACIÓN RUTINAS (Asignación por fechas)
    await db.execute('''
    CREATE TABLE ${DatabaseConfig.tableAssignRoutine} (
      ${DatabaseConfig.colAssignId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.colAssignDateTime} TEXT,
      ${DatabaseConfig.colRoutineId} INTEGER,
      FOREIGN KEY (${DatabaseConfig.colRoutineId}) 
        REFERENCES ${DatabaseConfig.tableRoutine} (${DatabaseConfig.colRoutineId})
    )
  ''');


  // 6. Tabla asignar favoritos (Asignacion por boleano)
    await db.execute("""
    CREATE TABLE ${DatabaseConfig.tableFrasesFavorits}(
      ${DatabaseConfig.recFrasesId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.recFrasesContenido} TEXT,
      ${DatabaseConfig.recFrasesFavorite} INTEGER
    )
    """);

    await db.execute('''
  CREATE TABLE ${DatabaseConfig.tableRelaxingAudios} (
    ${DatabaseConfig.recRelaxingAudioId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${DatabaseConfig.recRelaxingAudioTitle} TEXT NOT NULL,
    ${DatabaseConfig.recRelaxingAudioDurationSeconds} INTEGER,
    ${DatabaseConfig.recRelaxingAudioFilePath} TEXT NOT NULL,
    ${DatabaseConfig.recRelaxingAudioFileName} TEXT,
    ${DatabaseConfig.recRelaxingAudioFileSize} INTEGER,
    ${DatabaseConfig.recRelaxingAudioIsFavorite} INTEGER NOT NULL DEFAULT 0,
    ${DatabaseConfig.recRelaxingAudioCreatedAt} TEXT DEFAULT CURRENT_TIMESTAMP
  )
  ''');

  }
}

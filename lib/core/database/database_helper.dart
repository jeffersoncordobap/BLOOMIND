import 'package:bloomind/core/database/database_config.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

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
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: _onOpen,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final cols = await db.rawQuery('PRAGMA table_info(${DatabaseConfig.tableSurpriseActivities})');
      final existe = cols.any((c) => c['name'] == DatabaseConfig.colSurpriseActivityDeletedAt);
      if (!existe) {
        await db.execute(
          'ALTER TABLE ${DatabaseConfig.tableSurpriseActivities} ADD COLUMN ${DatabaseConfig.colSurpriseActivityDeletedAt} TEXT NULL',
        );
      }
    }
  }

  Future _onOpen(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${DatabaseConfig.tableSurpriseActivities}'),
    ) ?? 0;
    if (count == 0) {
      final jsonStr = await rootBundle.loadString('assets/actividades/actividades.json');
      final List<dynamic> frases = json.decode(jsonStr);
      final batch = db.batch();
      for (final frase in frases) {
        batch.insert(DatabaseConfig.tableSurpriseActivities, {
          DatabaseConfig.colSurpriseActivityDescription: frase as String,
          DatabaseConfig.colSurpriseActivityFavorite: 0,
        });
      }
      await batch.commit(noResult: true);
    }
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

    // 6. TABLA FRASES
    await db.execute("""
    CREATE TABLE ${DatabaseConfig.tableFrasesFavorits}(
      ${DatabaseConfig.recFrasesId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.recFrasesContenido} TEXT,
      ${DatabaseConfig.recFrasesFavorite} INTEGER
    )
    """);

    // 7. TABLA SURPRISE ACTIVITIES
    await db.execute("""
    CREATE TABLE ${DatabaseConfig.tableSurpriseActivities}(
      ${DatabaseConfig.colSurpriseActivityId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.colSurpriseActivityDescription} TEXT,
      ${DatabaseConfig.colSurpriseActivityFavorite} INTEGER DEFAULT 0,
      ${DatabaseConfig.colSurpriseActivityDeletedAt} TEXT NULL
    )
    """);

    //8.TABLA LINEAS DE APOYO
    await db.execute("""
    CREATE TABLE ${DatabaseConfig.tableSupportLines}(
      ${DatabaseConfig.colContactId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.colContactName} TEXT,
      ${DatabaseConfig.colContactPhone} TEXT,
      ${DatabaseConfig.colContactDescription} TEXT,
      ${DatabaseConfig.colIsFavoriteContact} INTEGER DEFAULT 0
    )
    """);




















    //9. Tabla de meditacion 
    await db.execute("""
    CREATE TABLE ${DatabaseConfig.tableAudiosMeditacion}(
      ${DatabaseConfig.recMeditationId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConfig.recMeditationTitle} TEXT,
      ${DatabaseConfig.recMeditationDescrip} TEXT, 
      ${DatabaseConfig.recMeditationDurat} TEXT, 
      ${DatabaseConfig.recMeditationFilepath} TEXT, 
      ${DatabaseConfig.recMeditationFavorite} INTEGER DEFAULT 0
    )
      """);




  }
}

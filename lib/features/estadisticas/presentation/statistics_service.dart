import 'package:bloomind/core/database/database_helper.dart';
import 'package:bloomind/core/database/database_config.dart';

import 'statistics_model.dart';

class StatisticsService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<StatisticsSummary> getWeeklySummary() async {
    final db = await _databaseHelper.database;

    final result = await db.query(DatabaseConfig.tableEmotion);

    if (result.isEmpty) {
      return StatisticsSummary(
        averageMood: 0,
        positiveDays: 0,
        neutralDays: 0,
        negativeDays: 0,
      );
    }

    double totalMood = 0;
    int positive = 0;
    int neutral = 0;
    int negative = 0;

    for (final row in result) {
      final mood = row[DatabaseConfig.colEmotionMoodLevel] as int? ?? 0;
      totalMood += mood;

      if (mood >= 4) {
        positive++;
      } else if (mood == 3) {
        neutral++;
      } else {
        negative++;
      }
    }

    return StatisticsSummary(
      averageMood: totalMood / result.length,
      positiveDays: positive,
      neutralDays: neutral,
      negativeDays: negative,
    );
  }
}
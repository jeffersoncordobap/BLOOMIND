import 'package:bloomind/core/database/database_config.dart';
import 'package:bloomind/core/database/database_helper.dart';
import 'package:bloomind/features/estadisticas/domain/statistics_model.dart';

class StatisticsService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<StatisticsSummary> getDailyStatistics(DateTime selectedDate) async {
    final db = await _databaseHelper.database;

    final rows = await db.query(DatabaseConfig.tableEmotion);

    if (rows.isEmpty) {
      return StatisticsSummary.empty();
    }

    final filtered = rows.where((row) {
      final dateText = row[DatabaseConfig.colEmotionDateTime] as String?;
      if (dateText == null || dateText.isEmpty) return false;

      final date = DateTime.tryParse(dateText);
      if (date == null) return false;

      return date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
    }).toList();

    if (filtered.isEmpty) {
      return StatisticsSummary.empty();
    }

    double totalMood = 0;

    for (final row in filtered) {
      final mood = (row[DatabaseConfig.colEmotionMoodLevel] as int?) ?? 0;
      totalMood += mood;
    }

    final dailyAverage = totalMood / filtered.length;

    return StatisticsSummary(
      averageMood: dailyAverage,
      positiveDays: 0,
      neutralDays: 0,
      negativeDays: 0,
      dailyAverage: dailyAverage,
      chartPoints: [],
    );
  }
}
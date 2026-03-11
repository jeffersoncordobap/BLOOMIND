import 'package:bloomind/core/database/database_config.dart';
import 'package:bloomind/core/database/database_helper.dart';
import 'package:bloomind/features/estadisticas/domain/statistics_model.dart';

class StatisticsService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<StatisticsSummary> getDailyStatistics(DateTime selectedDate) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(DatabaseConfig.tableEmotion);

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

    double totalMood = 0.0;

    for (final row in filtered) {
      final mood = (row[DatabaseConfig.colEmotionMoodLevel] as int?) ?? 0;
      totalMood += mood;
    }

    final double dailyAverage = totalMood / filtered.length;

    return StatisticsSummary(
      averageMood: dailyAverage,
      positiveDays: 0,
      neutralDays: 0,
      negativeDays: 0,
      dailyAverage: dailyAverage,
      chartPoints: const [],
    );
  }

  Future<StatisticsSummary> getWeeklyStatistics(DateTime selectedDate) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(DatabaseConfig.tableEmotion);

    final start = _startOfWeek(selectedDate);
    final labels = ['D', 'L', 'M', 'Mi', 'J', 'V', 'S'];

    final Map<int, List<int>> moodsByDayIndex = {
      0: [],
      1: [],
      2: [],
      3: [],
      4: [],
      5: [],
      6: [],
    };

    for (final row in rows) {
      final dateText = row[DatabaseConfig.colEmotionDateTime] as String?;
      final mood = (row[DatabaseConfig.colEmotionMoodLevel] as int?) ?? 0;

      if (dateText == null || dateText.isEmpty) continue;

      final date = DateTime.tryParse(dateText);
      if (date == null) continue;

      final normalized = DateTime(date.year, date.month, date.day);
      final diff = normalized.difference(start).inDays;

      if (diff >= 0 && diff < 7) {
        moodsByDayIndex[diff]!.add(mood);
      }
    }

    return _buildSummaryFromGroupedData(
      groupedData: moodsByDayIndex,
      labels: labels,
    );
  }

  Future<StatisticsSummary> getMonthlyStatistics(DateTime selectedDate) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(DatabaseConfig.tableEmotion);

    final int year = selectedDate.year;
    final int month = selectedDate.month;
    final int daysInMonth = DateTime(year, month + 1, 0).day;

    final Map<int, List<int>> moodsByDay = {
      for (int i = 1; i <= daysInMonth; i++) i: [],
    };

    for (final row in rows) {
      final dateText = row[DatabaseConfig.colEmotionDateTime] as String?;
      final mood = (row[DatabaseConfig.colEmotionMoodLevel] as int?) ?? 0;

      if (dateText == null || dateText.isEmpty) continue;

      final date = DateTime.tryParse(dateText);
      if (date == null) continue;

      if (date.year == year && date.month == month) {
        moodsByDay[date.day]!.add(mood);
      }
    }

    return _buildSummaryFromGroupedData(
      groupedData: moodsByDay,
      labels: List.generate(daysInMonth, (index) => '${index + 1}'),
    );
  }

  StatisticsSummary _buildSummaryFromGroupedData({
    required Map<int, List<int>> groupedData,
    required List<String> labels,
  }) {
    final List<ChartPoint> points = [];

    double totalAverageSum = 0.0;
    int countedDays = 0;

    int positiveDays = 0;
    int neutralDays = 0;
    int negativeDays = 0;

    final keys = groupedData.keys.toList()..sort();

    for (int i = 0; i < keys.length; i++) {
      final moods = groupedData[keys[i]] ?? [];

      double dayAverage = 0.0;

      if (moods.isNotEmpty) {
        final int sum = moods.reduce((a, b) => a + b);
        dayAverage = sum / moods.length;

        totalAverageSum += dayAverage;
        countedDays++;

        if (dayAverage >= 3.5) {
          positiveDays++;
        } else if (dayAverage >= 2.5) {
          neutralDays++;
        } else {
          negativeDays++;
        }
      }

      points.add(
        ChartPoint(
          label: labels[i],
          value: dayAverage,
        ),
      );
    }

    final double averageMood =
    countedDays > 0 ? totalAverageSum / countedDays : 0.0;

    return StatisticsSummary(
      averageMood: averageMood,
      positiveDays: positiveDays,
      neutralDays: neutralDays,
      negativeDays: negativeDays,
      dailyAverage: 0.0,
      chartPoints: points,
    );
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final daysFromSunday = normalized.weekday % 7;
    return normalized.subtract(Duration(days: daysFromSunday));
  }
}
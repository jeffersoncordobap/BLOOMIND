import '../../../core/database/database_config.dart';

class Activity {
  final int? idActivity;
  final String category;
  final String name;
  final String emoji;
  final String hour;

  Activity({
    this.idActivity,
    required this.category,
    required this.name,
    required this.emoji,
    required this.hour,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.colActivityId: idActivity,
      DatabaseConfig.colActivityCategory: category,
      DatabaseConfig.colActivityName: name,
      DatabaseConfig.colActivityEmoji: emoji,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      idActivity: map[DatabaseConfig.colActivityId],
      category: map[DatabaseConfig.colActivityCategory],
      name: map[DatabaseConfig.colActivityName],
      emoji: map[DatabaseConfig.colActivityEmoji],
      hour: map[DatabaseConfig.colRoutineActivityHour] ?? '',
    );
  }
}

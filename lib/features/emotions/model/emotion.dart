import '../../../core/database/database_config.dart';

class Emotion {
  final int? idEmotion;
  final int moodLevel;
  final String label;
  final String note;
  final String dateTime;
  final int state;

  Emotion({
    this.idEmotion,
    required this.moodLevel,
    required this.label,
    required this.note,
    required this.dateTime,
    this.state = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.colEmotionId: idEmotion,
      DatabaseConfig.colEmotionDateTime: dateTime,
      DatabaseConfig.colEmotionMoodLevel: moodLevel,
      DatabaseConfig.colEmotionLabel: label,
      DatabaseConfig.colEmotionNote: note,
      DatabaseConfig.colEmotionState: state,
    };
  }

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      idEmotion: map[DatabaseConfig.colEmotionId],
      moodLevel: map[DatabaseConfig.colEmotionMoodLevel],
      label: map[DatabaseConfig.colEmotionLabel],
      note: map[DatabaseConfig.colEmotionNote],
      dateTime: map[DatabaseConfig.colEmotionDateTime],
      state: map[DatabaseConfig.colEmotionState] ?? 1,
    );
  }

  String get emoji {
    switch (label.toLowerCase()) {
      case 'feliz':
        return '😄';
      case 'neutral':
        return '😐';
      case 'cansado':
        return '🥱';
      case 'triste':
        return '😢';
      case 'enojado':
        return '😡';
      case 'desmotivado':
        return '😞';
      default:
        return '😶';
    }
  }
}

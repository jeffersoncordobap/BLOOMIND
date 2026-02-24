import '../../../core/database/database_config.dart';

class AssignRoutine {
  final int? idAssignRoutine;
  final String dateTime; // formato ISO8601
  final int idRoutine;

  AssignRoutine({
    this.idAssignRoutine,
    required this.dateTime,
    required this.idRoutine,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.colAssignId: idAssignRoutine,
      DatabaseConfig.colAssignDateTime: dateTime,
      DatabaseConfig.colRoutineId: idRoutine,
    };
  }

  factory AssignRoutine.fromMap(Map<String, dynamic> map) {
    return AssignRoutine(
      idAssignRoutine: map[DatabaseConfig.colAssignId],
      dateTime: map[DatabaseConfig.colAssignDateTime],
      idRoutine: map[DatabaseConfig.colRoutineId],
    );
  }
}

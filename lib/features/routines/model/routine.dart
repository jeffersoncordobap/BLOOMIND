import '../../../core/database/database_config.dart';

class Routine {
  final int? idRoutine;
  final String name;

  Routine({this.idRoutine, required this.name});

  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.colRoutineId: idRoutine,
      DatabaseConfig.colRoutineName: name,
    };
  }

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      idRoutine: map[DatabaseConfig.colRoutineId],
      name: map[DatabaseConfig.colRoutineName],
    );
  }
}

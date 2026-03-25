import '../../../core/database/database_config.dart';

class Routine {
  final int? idRoutine;
  final String name;
  final int state;

  Routine({this.idRoutine, required this.name, this.state = 1});

  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.colRoutineId: idRoutine,
      DatabaseConfig.colRoutineName: name,
      DatabaseConfig.colRoutineState: state,
    };
  }

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      idRoutine: map[DatabaseConfig.colRoutineId],
      name: map[DatabaseConfig.colRoutineName],
      state: map[DatabaseConfig.colRoutineState] ?? 1,
    );
  }
}

import 'dart:async';
import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/repository/assign_routine_repository.dart';
import 'package:bloomind/features/routines/repository/routine_repository.dart';
import 'package:flutter/material.dart';

class RoutineProvider extends ChangeNotifier {
  final RoutineRepository routineRepo;
  final AssignRoutineRepository assignRepo;
  String _currentRoutineName = "Sin rutina asignada";
  String get currentRoutineName => _currentRoutineName;

  Activity? _nextActivity;
  Activity? get nextActivity => _nextActivity;

  Timer? _timer;

  RoutineProvider({required this.routineRepo, required this.assignRepo}) {
    updateUpcomingActivity();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updateUpcomingActivity();
    });
  }

  Future<void> updateUpcomingActivity() async {
    final hoy = DateTime.now().toIso8601String().split('T')[0];
    final asignacion = await assignRepo.getAssignmentByDate(hoy);

    if (asignacion != null) {
      final todasLasRutinas = await routineRepo.getAllRoutines();
      final rutinaActual = todasLasRutinas.firstWhere(
        (r) => r.idRoutine == asignacion.idRoutine,
        orElse: () => Routine(name: "Rutina desconocida"),
      );

      _currentRoutineName = rutinaActual.name;

      final actividades = await routineRepo.getActivitiesByRoutine(
        asignacion.idRoutine,
      ); //
      _nextActivity = _findClosestActivity(actividades);
    } else {
      _currentRoutineName = "No hay rutinas hoy";
      _nextActivity = null;
    }
    notifyListeners();
  }

  Activity? _findClosestActivity(List<Activity> actividades) {
    if (actividades.isEmpty) return null;

    final ahora = DateTime.now();
    final minutosAhora = ahora.hour * 60 + ahora.minute;

    Activity? candidata;
    int menorDiferencia = 1440;

    for (var actividad in actividades) {
      if (actividad.hour.isEmpty) continue;

      try {
        // Limpiamos espacios y pasamos a mayúsculas para comparar (e.g., " 4:40 pm " -> "4:40 PM")
        String horaRaw = actividad.hour.trim().toUpperCase();

        // Separamos la parte numérica de la parte AM/PM
        final partesEspacio = horaRaw.split(' ');
        final tiempo = partesEspacio[0];
        final amPm = partesEspacio.length > 1 ? partesEspacio[1] : '';

        final partesHora = tiempo.split(':');
        int hora = int.parse(partesHora[0]);
        int minutos = int.parse(partesHora[1]);

        // Conversión a formato 24h para la lógica de minutos
        if (amPm == 'PM' && hora != 12) hora += 12;
        if (amPm == 'AM' && hora == 12) hora = 0;

        final minutosActividad = hora * 60 + minutos;

        if (minutosActividad > minutosAhora) {
          final dif = minutosActividad - minutosAhora;
          if (dif < menorDiferencia) {
            menorDiferencia = dif;
            candidata = actividad;
          }
        }
      } catch (e) {
        debugPrint("Error parseando hora: ${actividad.hour} -> $e");
      }
    }
    return candidata;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

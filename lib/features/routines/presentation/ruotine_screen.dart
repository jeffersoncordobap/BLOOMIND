import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/routines/presentation/provider/routine_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineScreen extends StatelessWidget {
  final VoidCallback alPresionarListaRutinas;
  final VoidCallback alPresionarAsignarRutinas;
  final VoidCallback alPresionarVerRutinaDia;

  const RoutineScreen({
    super.key,
    required this.alPresionarListaRutinas,
    required this.alPresionarAsignarRutinas,
    required this.alPresionarVerRutinaDia,
  });

  @override
  Widget build(BuildContext context) {
    // Escuchamos el provider para obtener la próxima actividad
    final routineProvider = context.watch<RoutineProvider>(); //
    final nextActivity = routineProvider.nextActivity; //
    final routineName = routineProvider.currentRoutineName;

    return Scaffold(
      appBar: AppBar(title: const Text('Rutinas'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          children: [
            _buildUpcomingCard(nextActivity, routineName),

            const SizedBox(height: 23),

            _buildPrimaryButton(
              text: 'Ver rutina del día',
              onTap: alPresionarVerRutinaDia,
            ),

            const SizedBox(height: 18),

            _buildPrimaryButton(
              text: 'Asignar rutinas',
              onTap: alPresionarAsignarRutinas,
            ),

            const SizedBox(height: 18),

            _buildPrimaryButton(
              text: 'Ver mis rutinas',
              onTap: alPresionarListaRutinas,
            ),
          ],
        ),
      ),
    );
  }

  // Widget de la Tarjeta de Próxima Actividad
  Widget _buildUpcomingCard(Activity? actividad, String routineName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("Rutina de hoy", style: TextStyle(color: Colors.blueGrey)),
          Text(
            routineName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Divider(height: 30),
          if (actividad != null) ...[
            const Text("Próxima actividad"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(actividad.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(
                  actividad.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              "${actividad.hour} · ${actividad.category}",
              style: const TextStyle(color: Colors.grey),
            ),
          ] else
            const Text("No hay más actividades para hoy"),
        ],
      ),
    );
  }

  // Widget reutilizable para los botones
  static Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4D86C7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

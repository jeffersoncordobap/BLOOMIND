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
    final routineProvider = context.watch<RoutineProvider>();
    final nextActivity = routineProvider.nextActivity;
    final routineName = routineProvider.currentRoutineName;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Rutinas'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          children: [
            _buildUpcomingCard(nextActivity, routineName, colorScheme),
            const SizedBox(height: 23),
            _buildPrimaryButton(
              text: 'Ver rutina del día',
              onTap: alPresionarVerRutinaDia,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 18),
            _buildPrimaryButton(
              text: 'Asignar rutinas',
              onTap: alPresionarAsignarRutinas,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 18),
            _buildPrimaryButton(
              text: 'Ver mis rutinas',
              onTap: alPresionarListaRutinas,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta de próxima actividad
  Widget _buildUpcomingCard(Activity? actividad, String routineName, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant, // tema dinámico
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            "Rutina de hoy",
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 4),
          Text(
            routineName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
          Divider(height: 30, color: colorScheme.onSurface.withValues(alpha: 0.3)),
          if (actividad != null) ...[
            Text("Próxima actividad", style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(actividad.emoji, style: TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(
                  actividad.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              "${actividad.hour} · ${actividad.category}",
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ] else
            Text(
              "No hay más actividades para hoy",
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
        ],
      ),
    );
  }

  // Botones principales
  static Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
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
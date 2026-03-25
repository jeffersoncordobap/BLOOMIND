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
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        title: Text(
          'Rutinas',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUpcomingCard(context, nextActivity, routineName),
              const SizedBox(height: 24),

              _buildActionCard(
                context: context,
                title: 'Ver rutina del día',
                subtitle: 'Consulta las actividades que tienes programadas hoy',
                icon: Icons.today_rounded,
                iconBackground: colorScheme.primaryContainer,
                iconColor: colorScheme.onPrimaryContainer,
                onTap: alPresionarVerRutinaDia,
              ),

              const SizedBox(height: 16),

              _buildActionCard(
                context: context,
                title: 'Asignar rutinas',
                subtitle: 'Organiza y asigna una rutina a tus días',
                icon: Icons.auto_awesome_motion_rounded,
                iconBackground: colorScheme.primaryContainer,
                iconColor: colorScheme.onPrimaryContainer,
                onTap: alPresionarAsignarRutinas,
              ),

              const SizedBox(height: 16),

              _buildActionCard(
                context: context,
                title: 'Ver mis rutinas',
                subtitle: 'Revisa todas las rutinas que ya has creado',
                icon: Icons.menu_book_rounded,
                iconBackground: colorScheme.primaryContainer,
                iconColor: colorScheme.onPrimaryContainer,
                onTap: alPresionarListaRutinas,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, Activity? actividad, String routineName) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasRoutine = routineName.trim().isNotEmpty;
    final displayRoutineName = hasRoutine ? routineName : 'Sin rutina asignada';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.4),
            colorScheme.primaryContainer.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.self_improvement_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rutina de hoy',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tu guía para organizar el día',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            displayRoutineName,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            height: 1,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          if (actividad != null) ...[
            Text(
              'Próxima actividad',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.72),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      actividad.emoji,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          actividad.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${actividad.hour} · ${actividad.category}',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.72),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No hay más actividades para hoy',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outline),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
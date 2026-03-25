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

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text(
          'Rutinas',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF22324A),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF7F1F7),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUpcomingCard(nextActivity, routineName),
              const SizedBox(height: 24),

              _buildActionCard(
                title: 'Ver rutina del día',
                subtitle: 'Consulta las actividades que tienes programadas hoy',
                icon: Icons.today_rounded,
                iconBackground: const Color(0xFFDCEBFF),
                iconColor: const Color(0xFF4D86C7),
                onTap: alPresionarVerRutinaDia,
              ),

              const SizedBox(height: 16),

              _buildActionCard(
                title: 'Asignar rutinas',
                subtitle: 'Organiza y asigna una rutina a tus días',
                icon: Icons.auto_awesome_motion_rounded,
                iconBackground: const Color(0xFFE4F4E8),
                iconColor: const Color(0xFF4FA36C),
                onTap: alPresionarAsignarRutinas,
              ),

              const SizedBox(height: 16),

              _buildActionCard(
                title: 'Ver mis rutinas',
                subtitle: 'Revisa todas las rutinas que ya has creado',
                icon: Icons.menu_book_rounded,
                iconBackground: const Color(0xFFFFE8D9),
                iconColor: const Color(0xFFDD8A4D),
                onTap: alPresionarListaRutinas,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(Activity? actividad, String routineName) {
    final hasRoutine = routineName.trim().isNotEmpty;
    final displayRoutineName = hasRoutine ? routineName : 'Sin rutina asignada';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDCEBFA),
            Color(0xFFEAF3FB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD5E3F2),
        ),
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
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.self_improvement_rounded,
                  color: Color(0xFF4D86C7),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rutina de hoy',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7B8F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tu guía para organizar el día',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A98AA),
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
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: Color(0xFF1F2B44),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFFC8D5E3),
          ),
          const SizedBox(height: 16),
          if (actividad != null) ...[
            const Text(
              'Próxima actividad',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7B8F),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      actividad.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          actividad.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF1F2B44),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${actividad.hour} · ${actividad.category}',
                          style: const TextStyle(
                            color: Color(0xFF6E7D90),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF8AA0B8),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF4FA36C),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No hay más actividades para hoy',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF556579),
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
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE3E9F1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
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
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2B44),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF708094),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Color(0xFF9AA9BA),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
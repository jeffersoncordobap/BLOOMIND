import 'package:bloomind/features/settings/presentation/bin_screen.dart';
import 'package:bloomind/features/settings/presentation/tema_visual.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloomind/features/notifications/presentation/notification_settings_screen.dart';
import 'package:bloomind/features/settings/presentation/profile_screen.dart';
import 'package:bloomind/features/settings/controller/profile_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfileController>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colorScheme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(controller, colorScheme),
                    const SizedBox(height: 22),

                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'Preferencias',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),

                    _buildOptionCard(
                      context,
                      icon: Icons.person_rounded,
                      iconColor: colorScheme.primary,
                      iconBackground: colorScheme.primary.withOpacity(0.1),
                      title: 'Perfil local',
                      subtitle: 'Personaliza tu experiencia en la app',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildOptionCard(
                      context,
                      icon: Icons.palette_rounded,
                      iconColor: colorScheme.secondary,
                      iconBackground: colorScheme.secondary.withOpacity(0.1),
                      title: 'Tema visual',
                      subtitle: 'Ajusta colores y apariencia',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TemaVisualScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildOptionCard(
                      context,
                      icon: Icons.notifications_rounded,
                      iconColor: colorScheme.tertiary,
                      iconBackground: colorScheme.tertiary.withOpacity(0.1),
                      title: 'Notificaciones',
                      subtitle: 'Gestiona recordatorios y avisos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const NotificationSettingsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    _buildOptionCard(
                      context,
                      icon: Icons.delete,
                      iconColor: colorScheme.error,
                      iconBackground: colorScheme.error.withOpacity(0.1),
                      title: 'Papelera',
                      subtitle: 'Recupera o elimina elementos archivados',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PapeleraScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Configuración',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(
      ProfileController controller, ColorScheme colorScheme) {
    String saludo = 'Bienvenido/a';
    if (controller.profile.genero == 'Masculino') saludo = 'Bienvenido';
    if (controller.profile.genero == 'Femenino') saludo = 'Bienvenida';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            saludo,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Text(
                  controller.profile.emoji.isEmpty
                      ? '😊'
                      : controller.profile.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.profile.nombre.isEmpty
                      ? 'Perfil local'
                      : controller.profile.nombre,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
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
                        fontSize: 13.5,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
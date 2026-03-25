import 'package:flutter/material.dart';
import 'package:bloomind/features/notifications/presentation/notification_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 22),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'Preferencias',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6E7C91),
                        ),
                      ),
                    ),
                    _buildOptionCard(
                      context,
                      icon: Icons.person_rounded,
                      iconColor: const Color(0xFF7C4DCC),
                      iconBackground: const Color(0xFFF1E8FF),
                      title: 'Perfil local',
                      subtitle: 'Personaliza tu experiencia en la app',
                      onTap: () {
                        // Navegar a perfil
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      context,
                      icon: Icons.palette_rounded,
                      iconColor: const Color(0xFFE78C95),
                      iconBackground: const Color(0xFFFFEEF1),
                      title: 'Tema visual',
                      subtitle: 'Ajusta colores y apariencia',
                      onTap: () {
                        // Navegar a tema visual
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      context,
                      icon: Icons.notifications_rounded,
                      iconColor: const Color(0xFFF0A93E),
                      iconBackground: const Color(0xFFFFF4DF),
                      title: 'Notificaciones',
                      subtitle: 'Gestiona recordatorios y avisos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationSettingsScreen(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Configuración',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF26344A),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEAF3FF),
            Color(0xFFF4F8FF),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido/a',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7B8AA0),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Text(
                  '😊',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Perfil local',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF24344B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            'Género: Prefiero no decir',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5D7390),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Este perfil personaliza saludos, textos clave y tus resúmenes dentro de Bloomind.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5D7390),
              height: 1.45,
            ),
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
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
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF22324B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF7C889A),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF7A879A),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
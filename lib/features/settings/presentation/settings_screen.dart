import 'package:bloomind/features/settings/presentation/tema_visual.dart';
import 'package:flutter/material.dart';
import 'package:bloomind/features/notifications/presentation/notification_settings_screen.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F6),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 18),
                    _buildOptionCard(
                      context,
                      icon: Icons.person,
                      iconColor: const Color(0xFF6A3FA0),
                      title: 'Perfil local',
                      onTap: () {
                        // Navegar a pantalla de perfil
                      },
                    ),
                    const SizedBox(height: 18),
                    _buildOptionCard(
                      context,
                      icon: Icons.palette,
                      iconColor: const Color(0xFFF5A6A6),
                      title: 'Tema visual',
                      onTap: () {
                        // Navegar a pantalla de tema visual
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => const TemaVisualScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    _buildOptionCard(
                      context,
                      icon: Icons.notifications,
                      iconColor: const Color(0xFFF2B544),
                      title: 'Notificaciones',
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
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Configuración',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F3B52),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F0FA),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido/a',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7A90),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                '😊',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Perfil local',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF23324A),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Género: Prefiero no decir',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF58708E),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Este perfil personaliza saludos, textos clave y tus resúmenes.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF58708E),
              height: 1.4,
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
        required String title,
        required VoidCallback onTap,
      }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: const Color(0x22000000),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF22324B),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF7A879A),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }


}

class _BottomIcon extends StatelessWidget {
  final String icon;
  final bool isSelected;

  const _BottomIcon({
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE7EAF2) : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        icon,
        style: const TextStyle(fontSize: 28),
      ),
    );
  }
}
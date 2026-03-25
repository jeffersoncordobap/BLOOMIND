import 'package:bloomind/features/settings/controller/bin_controller.dart';
import 'package:bloomind/features/settings/presentation/bin_activities_screen.dart';
import 'package:bloomind/features/settings/presentation/bin_emotions_screen.dart';
import 'package:bloomind/features/settings/presentation/bin_routines_screen.dart';
import 'package:bloomind/features/settings/presentation/bin_support_lines_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PapeleraScreen extends StatelessWidget {
  const PapeleraScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Esta papelera estará disponible próximamente.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BinController()
        ..loadDeletedEmotions()
        ..loadDeletedActivities()
        ..loadDeletedRoutines()
        ..loadDeletedSupportLines(), // Cargamos también líneas de apoyo
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        appBar: AppBar(
          title: const Text(
            'Papelera',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Consumer<BinController>(
            builder: (context, binController, child) {
              return ListView(
                children: [
                  // 1. Papelera Emociones
                  _CardPapelera(
                    emoji: '😄',
                    nombre: 'Papelera emociones',
                    count: binController.deletedEmotions.length,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: binController,
                            child: const OnlyEmotionsRemovedScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // 2. Papelera Actividades
                  _CardPapelera(
                    emoji: '⏰',
                    nombre: 'Papelera actividades',
                    count: binController.deletedActivities.length,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: binController,
                            child: const OnlyActivitiesRemovedScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // 3. Papelera Rutinas
                  _CardPapelera(
                    emoji: '🏋️‍♂️',
                    nombre: 'Papelera Rutinas',
                    count: binController.deletedRoutines.length,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: binController,
                            child: const BinRoutinesScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // 4. Papelera Líneas de apoyo
                  _CardPapelera(
                    emoji: '❤️',
                    nombre: 'Papelera líneas de apoyo',
                    count: binController.deletedSupportLines.length,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: binController,
                            child: const BinSupportLinesScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CardPapelera extends StatelessWidget {
  final String emoji;
  final String nombre;
  final int count;
  final VoidCallback onTap;

  const _CardPapelera({
    required this.emoji,
    required this.nombre,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$count Eliminado${count == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

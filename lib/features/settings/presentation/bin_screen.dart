import 'package:bloomind/features/settings/controller/bin_controller.dart';
import 'package:bloomind/features/settings/presentation/bin_activities_screen.dart';
import 'package:bloomind/features/settings/presentation/bin_emotions_screen.dart';
import 'package:bloomind/features/settings/presentation/bin_routines_screen.dart';
import 'package:bloomind/features/settings/presentation/bin_support_lines_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PapeleraScreen extends StatelessWidget {
  const PapeleraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (_) => BinController()
        ..loadDeletedEmotions()
        ..loadDeletedActivities()
        ..loadDeletedRoutines()
        ..loadDeletedSupportLines(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Papelera',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
        ),
        body: Consumer<BinController>(
          builder: (context, binController, child) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Aquí encontrarás los elementos eliminados recientemente.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.85,
                      children: [
                        _CardPapelera(
                          emoji: '😄',
                          nombre: 'Emociones',
                          count: binController.deletedEmotions.length,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: binController,
                                child: const OnlyEmotionsRemovedScreen(),
                              ),
                            ),
                          ),
                        ),
                        _CardPapelera(
                          emoji: '⏰',
                          nombre: 'Actividades',
                          count: binController.deletedActivities.length,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: binController,
                                child: const OnlyActivitiesRemovedScreen(),
                              ),
                            ),
                          ),
                        ),
                        _CardPapelera(
                          emoji: '🏋️‍♂️',
                          nombre: 'Rutinas',
                          count: binController.deletedRoutines.length,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: binController,
                                child: const BinRoutinesScreen(),
                              ),
                            ),
                          ),
                        ),
                        _CardPapelera(
                          emoji: '❤️',
                          nombre: 'Líneas de apoyo',
                          count: binController.deletedSupportLines.length,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: binController,
                                child: const BinSupportLinesScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 35)),
                ),
                const SizedBox(height: 16),
                Text(
                  nombre,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: count > 0
                        ? colorScheme.primary.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count ítem${count == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: count > 0 ? colorScheme.primary : Colors.grey,
                    ),
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

import 'package:bloomind/features/resourses/favorite_interfaz/meditation_favorite_interfaz.dart';
import 'package:bloomind/features/resourses/presentation/surprise_activity_favorites_screen.dart';
import 'package:bloomind/features/resourses/repository/resourse_meditation_repository.dart';
import 'package:bloomind/features/resourses/repository/resourse_meditation_repository_impl.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/database/database_helper.dart';
import '../../relaxing_audio/controller/relaxing_audio_controller.dart';
import '../../relaxing_audio/presentation/favorite_audio_screen.dart';
import '../../relaxing_audio/repository/relaxing_audio_repository_impl.dart';

import '../controller/support_line_controller.dart';
import '../favorite_interfaz/frases_favorite_interfaz.dart';
import '../repository/resourse_repository.dart';
import '../repository/resourse_repository_impl.dart';
import '../repository/surprise_activity_repository.dart';
import '../repository/surprise_activity_repository_impl.dart';
import 'only_favorites_support_lines_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final ResourseRepository _repository = ResourseRepositoryImpl();
  final SurpriseActivityRepository _surpriseRepository =
      SurpriseActivityRepositoryImpl();
  int _surpriseFavoritas = 0;
  final ResourseMeditationRepository _repositoryMeditation =
      ResourseMeditationRepositoryImpl();
  int _frasesFavoritas = 0;
  int _meditationFavoritas = 0;

  @override
  void initState() {
    super.initState();
    _cargarContadores();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SupportLineController>().loadFavorites();
    });
  }

  Future<void> _cargarContadores() async {
    final frases = await _repository.getAllFrases();
    final surpriseCount = await _surpriseRepository.countFavoritos();
    final meditation = await _repositoryMeditation.getAllMeditations();

    if (!mounted) return;

    setState(() {
      _frasesFavoritas = frases.where((f) => f.favorita_frase).length;
      _surpriseFavoritas = surpriseCount;
      _meditationFavoritas = meditation
          .where((m) => m.favorite_meditation)
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final supportController = context.watch<SupportLineController>();
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (_) =>
          RelaxingAudioController(RelaxingAudioRepositoryImpl(DatabaseHelper()))
            ..loadFavoriteAudios(),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Mis Favoritos',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: colorScheme.surface,
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _GridCardFavorito(
                    colorScheme: colorScheme,
                    emoji: '🧘',
                    nombre: 'Meditación',
                    count: _meditationFavoritas,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const WidgetMeditacionFavorite(),
                        ),
                      );
                      if (!mounted) return;
                      _cargarContadores();
                    },
                  ),
                  _GridCardFavorito(
                    colorScheme: colorScheme,
                    emoji: '☁️',
                    nombre: 'Frases',
                    count: _frasesFavoritas,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritasFrasesScreen(),
                        ),
                      );
                      if (!mounted) return;
                      _cargarContadores();
                    },
                  ),
                  Consumer<RelaxingAudioController>(
                    builder: (context, controller, child) {
                      return _GridCardFavorito(
                        colorScheme: colorScheme,
                        emoji: '🎧',
                        nombre: 'Audios',
                        count: controller.favoriteAudios.length,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: controller,
                                child: const FavoriteAudioScreen(),
                              ),
                            ),
                          );
                          if (!mounted) return;
                          controller.loadFavoriteAudios();
                        },
                      );
                    },
                  ),
                  _GridCardFavorito(
                    colorScheme: colorScheme,
                    emoji: '🎁',
                    nombre: 'Actividades',
                    count: _surpriseFavoritas,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SurpriseActivityFavoritesScreen(),
                        ),
                      );
                      if (!mounted) return;
                      _cargarContadores();
                    },
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: _WideCardFavorito(
                  colorScheme: colorScheme,
                  emoji: '❤️',
                  nombre: 'Líneas de apoyo',
                  count: supportController.favoriteLines.length,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OnlyFavoritesSupportLinesScreen(),
                      ),
                    );
                    if (!mounted) return;
                    context.read<SupportLineController>().loadFavorites();
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _GridCardFavorito extends StatelessWidget {
  final ColorScheme colorScheme;
  final String emoji;
  final String nombre;
  final int count;
  final VoidCallback onTap;

  const _GridCardFavorito({
    required this.colorScheme,
    required this.emoji,
    required this.nombre,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text(
                  nombre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count ítem${count == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.6),
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

class _WideCardFavorito extends StatelessWidget {
  final ColorScheme colorScheme;
  final String emoji;
  final String nombre;
  final int count;
  final VoidCallback onTap;

  const _WideCardFavorito({
    required this.colorScheme,
    required this.emoji,
    required this.nombre,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.7),
            colorScheme.surfaceVariant.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '$count guardados',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

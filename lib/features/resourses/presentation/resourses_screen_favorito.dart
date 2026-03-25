import 'package:bloomind/features/resourses/favorite_interfaz/meditation_favorite_interfaz.dart';
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
import 'only_favorites_support_lines_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final ResourseRepository _repository = ResourseRepositoryImpl();
  final ResourseMeditationRepository _repositoryMeditation = ResourseMeditationRepositoryImpl();
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
    final meditation = await _repositoryMeditation.getAllMeditations(); 

    if (!mounted) return;


    setState(() {
      _frasesFavoritas = frases.where((f) => f.favorita_frase).length;
      _meditationFavoritas = meditation.where((m) => m.favorite_meditation).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final supportController = context.watch<SupportLineController>();

    return ChangeNotifierProvider(
      create: (_) => RelaxingAudioController(
        RelaxingAudioRepositoryImpl(DatabaseHelper()),
      )..loadFavoriteAudios(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        appBar: AppBar(
          title: const Text(
            'Favoritos',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            children: [
              // 1. MEDITACIÓN
              _CardFavorito(
                emoji: '🧘',
                nombre: 'Meditación y respiración',
                count: _meditationFavoritas,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WidgetMeditacionFavorite(),
                    ),
                  );

                  if (!mounted) return;

                  final mainNavState = context
                      .findAncestorStateOfType<MainNavigationScreenState>();
                  mainNavState?.meditacionKey.currentState?.meditationRefresh();
                },
              ),
              const SizedBox(height: 12),

              // 2. FRASES
              _CardFavorito(
                emoji: '☁️',
                nombre: 'Frases y motivación',
                count: _frasesFavoritas,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritasFrasesScreen(),
                    ),
                  );

                  if (!mounted) return;

                  await _cargarContadores();

                  final mainNavState = context
                      .findAncestorStateOfType<MainNavigationScreenState>();
                  mainNavState?.frasesKey.currentState?.refreshFrases();
                },
              ),
              const SizedBox(height: 12),

              // 3. AUDIOS RELAJANTES
              Consumer<RelaxingAudioController>(
                builder: (context, controller, child) {
                  return _CardFavorito(
                    emoji: '🎧',
                    nombre: 'Audios relajantes',
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
                      await context
                          .read<RelaxingAudioController>()
                          .loadFavoriteAudios();
                    },
                  );
                },
              ),
              const SizedBox(height: 12),

              // 4. LÍNEAS DE APOYO
              _CardFavorito(
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
                  await context.read<SupportLineController>().loadFavorites();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardFavorito extends StatelessWidget {
  final String emoji;
  final String nombre;
  final int count;
  final VoidCallback onTap;

  const _CardFavorito({
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
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
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
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 30),
                ),
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
                        '$count favorito${count == 1 ? '' : 's'}',
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
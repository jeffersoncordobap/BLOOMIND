import 'package:flutter/material.dart';
import '../repository/resourse_repository.dart';
import '../repository/resourse_repository_impl.dart';
import 'package:provider/provider.dart';

import '../../../core/database/database_helper.dart';
import '../../relaxing_audio/controller/relaxing_audio_controller.dart';
import '../../relaxing_audio/presentation/favorite_audio_screen.dart';
import '../../relaxing_audio/repository/relaxing_audio_repository_impl.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final ResourseRepository _repository = ResourseRepositoryImpl();
  int _frasesFavoritas = 0;

  @override
  void initState() {
    super.initState();
    _cargarContadores();
  }

  Future<void> _cargarContadores() async {
    final frases = await _repository.getAllFrases();
    if (mounted) {
      setState(() {
        _frasesFavoritas = frases.where((f) => f.favorita_frase).length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RelaxingAudioController(
        RelaxingAudioRepositoryImpl(DatabaseHelper()),
      )..loadFavoriteAudios(),
      child: Builder(
        builder: (context) {
          return Scaffold(
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
                  _CardFavorito(
                    emoji: '🧘',
                    nombre: 'Meditación y respiración',
                    count: 0,
                    onTap: () {
                      print("Navegando a Meditación...");
                    },
                  ),
                  const SizedBox(height: 12),

                  _CardFavorito(
                    emoji: '☁️',
                    nombre: 'Frases y motivación',
                    count: _frasesFavoritas,
                    onTap: () {
                      print("Navegando a Frases...");
                    },
                  ),
                  const SizedBox(height: 12),

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

                  _CardFavorito(
                    emoji: '🎁',
                    nombre: 'Actividades sorpresa',
                    count: 0,
                    onTap: () {
                      print("Navegando a Actividades sorpresa...");
                    },
                  ),
                  const SizedBox(height: 12),

                  _CardFavorito(
                    emoji: '❤️',
                    nombre: 'Líneas de apoyo',
                    count: 0,
                    onTap: () {
                      print("Navegando a Líneas de Apoyo...");
                    },
                  ),
                ],
              ),
            ),
          );
        },
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




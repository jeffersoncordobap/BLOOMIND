import 'package:bloomind/features/resourses/repository/resourse_meditation_repository.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../model/meditation.dart';
import '../repository/resourse_meditation_repository_impl.dart';
import '../contenido/meditaciones_data.dart';

class widget_meditacion extends StatefulWidget {
  const widget_meditacion({super.key});

  @override
  State<widget_meditacion> createState() => widget_meditacionState();
}

class widget_meditacionState extends State<widget_meditacion> {
  final resourseMeditationRepo = ResourseMeditationRepositoryImpl();
  final AudioPlayer _player = AudioPlayer();
  int? currentIndex;

  List<ResourseMeditation> audios = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void meditationRefresh() async {
    audios = await resourseMeditationRepo.getAllMeditations();
    setState(() {});
  }

  Future<void> _loadAudios() async {
    try {
      final audiosFromDB = await resourseMeditationRepo.getAllMeditations();
      setState(() {
        audios = audiosFromDB;
      });
    } catch (e) {
      print("Error cargando audios desde la DB: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (audios.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("Meditación y respiración"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(2);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: audios.length,
          itemBuilder: (context, index) {
            final audio = audios[index];
            final isCurrent = currentIndex == index;

            return Card(
              color: colorScheme.surface,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snapshot) {
                        final isPlaying = snapshot.data?.playing ?? false;
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? colorScheme.primary.withValues(alpha: 0.3)
                                : colorScheme.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCurrent && isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: colorScheme.primary,
                          ),
                        );
                      },
                    ),
                    title: Text(
                      audio.title_meditation,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    subtitle: Text(
                      audio.descripcion_meditation,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        audio.favorite_meditation
                            ? Icons.star
                            : Icons.star_border,
                        color: audio.favorite_meditation
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      onPressed: () async {
                        final updatedAudio = ResourseMeditation(
                          id_meditacion: audio.id_meditacion,
                          title_meditation: audio.title_meditation,
                          descripcion_meditation:
                              audio.descripcion_meditation,
                          duration_meditation:
                              audio.duration_meditation,
                          filepath_meditation:
                              audio.filepath_meditation,
                          favorite_meditation:
                              !audio.favorite_meditation,
                        );

                        setState(() {
                          audios[index] = updatedAudio;
                        });

                        try {
                          await ResourseMeditationRepositoryImpl()
                              .updateMeditation(updatedAudio);
                        } catch (e) {
                          print("Error actualizando favorito en la DB: $e");
                        }
                      },
                    ),
                    onTap: () => playAudio(audio, index),
                  ),

                  if (isCurrent)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: StreamBuilder<Duration?>(
                        stream: _player.durationStream,
                        builder: (context, durationSnap) {
                          final total = durationSnap.data ?? Duration.zero;
                          return StreamBuilder<Duration>(
                            stream: _player.positionStream,
                            builder: (context, posSnap) {
                              final position =
                                  posSnap.data ?? Duration.zero;
                              return Column(
                                children: [
                                  Slider(
                                    value: position.inSeconds
                                        .toDouble()
                                        .clamp(0,
                                            total.inSeconds.toDouble()),
                                    max: total.inSeconds
                                        .toDouble()
                                        .clamp(1, double.infinity),
                                    onChanged: (val) {
                                      _player.seek(
                                          Duration(seconds: val.toInt()));
                                    },
                                    activeColor: colorScheme.primary,
                                    inactiveColor: colorScheme.primary
                                        .withValues(alpha: 0.2),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(position),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(total),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
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

  Future<void> playAudio(ResourseMeditation audio, int index) async {
    try {
      if (currentIndex != index) {
        await _player.setAsset(audio.filepath_meditation);
        currentIndex = index;
        await _player.play();
      } else {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
      }
      setState(() {});
    } catch (e) {
      print("Error reproduciendo audio: $e");
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> seedMeditations() async {
    final ResourseMeditationRepository _repository =
        ResourseMeditationRepositoryImpl();
    final AudiosIniciales = audios_guardar;

    final meditacionesExistentes =
        await _repository.getAllMeditations();

    for (ResourseMeditation audios in AudiosIniciales) {
      bool existe = meditacionesExistentes.any(
          (f) => f.title_meditation == audios.title_meditation);
      if (!existe) {
        await _repository.createMeditation(
          ResourseMeditation(
            id_meditacion: audios.id_meditacion,
            title_meditation: audios.title_meditation,
            descripcion_meditation:
                audios.descripcion_meditation,
            duration_meditation:
                audios.duration_meditation,
            filepath_meditation:
                audios.filepath_meditation,
            favorite_meditation:
                audios.favorite_meditation,
          ),
        );
      }
    }
  }

  Future<void> _initializeData() async {
    await seedMeditations();
    await _loadAudios();
  }
}
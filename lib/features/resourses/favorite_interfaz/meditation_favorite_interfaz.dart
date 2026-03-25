import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../model/meditation.dart';
import '../repository/resourse_meditation_repository_impl.dart';
import '../contenido/meditaciones_data.dart';

class WidgetMeditacionFavorite extends StatefulWidget {
  const WidgetMeditacionFavorite({super.key});

  @override
  State<WidgetMeditacionFavorite> createState() =>
      WidgetMeditacionFavoriteState();
}

class WidgetMeditacionFavoriteState extends State<WidgetMeditacionFavorite> {
  final AudioPlayer _player = AudioPlayer();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<ResourseMeditation> _favoritas = [];
  bool _loading = true;
  int? currentIndex;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _seedMeditations();
    await _loadFavoritas();
  }

  Future<void> _seedMeditations() async {
    final repository = ResourseMeditationRepositoryImpl();
    final existing = await repository.getAllMeditations();

    for (var audio in audios_guardar) {
      bool existe = existing.any((e) => e.title_meditation == audio.title_meditation);
      if (!existe) {
        await repository.createMeditation(audio);
      }
    }
  }

  Future<void> _loadFavoritas() async {
    final repository = ResourseMeditationRepositoryImpl();
    try {
      final all = await repository.getAllMeditations();
      setState(() {
        _favoritas = all.where((a) => a.favorite_meditation).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Error cargando audios favoritos: $e");
    }
  }

  Future<void> _quitarFavorito(int index) async {
    final audio = _favoritas[index];
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildCard(audio, index, animation),
      duration: const Duration(milliseconds: 300),
    );
    _favoritas.removeAt(index);

    final updated = ResourseMeditation(
      id_meditacion: audio.id_meditacion,
      title_meditation: audio.title_meditation,
      descripcion_meditation: audio.descripcion_meditation,
      duration_meditation: audio.duration_meditation,
      filepath_meditation: audio.filepath_meditation,
      favorite_meditation: false,
    );

    try {
      await ResourseMeditationRepositoryImpl().updateMeditation(updated);
    } catch (e) {
      setState(() {
        _favoritas.insert(index, audio);
        _listKey.currentState?.insertItem(index);
      });
      debugPrint("Error actualizando favorito en la DB: $e");
    }
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
      debugPrint("Error reproduciendo audio: $e");
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return Scaffold(
        backgroundColor: colorScheme.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_favoritas.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Meditación y respiración"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_border_rounded, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              Text(
                'No tienes meditaciones favoritas aún',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meditación y respiración"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: colorScheme.background,
      body: AnimatedList(
        key: _listKey,
        padding: const EdgeInsets.all(8),
        initialItemCount: _favoritas.length,
        itemBuilder: (context, index, animation) {
          final audio = _favoritas[index];
          return _buildCard(audio, index, animation);
        },
      ),
    );
  }

  Widget _buildCard(ResourseMeditation audio, int index, Animation<double> animation) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCurrent = currentIndex == index;

    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: colorScheme.surface,
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
                            ? colorScheme.primary.withValues(alpha: 0.2)
                            : colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCurrent && isPlaying ? Icons.pause : Icons.play_arrow,
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
                  style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8)),
                ),
                trailing: IconButton(
                  icon: Icon(
                    audio.favorite_meditation ? Icons.star : Icons.star_border,
                    color: audio.favorite_meditation
                        ? colorScheme.secondary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  onPressed: () => _quitarFavorito(index),
                ),
                onTap: () => playAudio(audio, index),
              ),
              if (isCurrent)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: StreamBuilder<Duration?>(
                    stream: _player.durationStream,
                    builder: (context, durSnap) {
                      final total = durSnap.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, posSnap) {
                          final pos = posSnap.data ?? Duration.zero;
                          return Column(
                            children: [
                              Slider(
                                value: pos.inSeconds.toDouble().clamp(0, total.inSeconds.toDouble()),
                                max: total.inSeconds.toDouble().clamp(1, double.infinity),
                                onChanged: (val) => _player.seek(Duration(seconds: val.toInt())),
                                activeColor: colorScheme.primary,
                                inactiveColor: colorScheme.primary.withValues(alpha: 0.2),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDuration(pos),
                                      style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.6))),
                                  Text(_formatDuration(total),
                                      style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.6))),
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
        ),
      ),
    );
  }
}
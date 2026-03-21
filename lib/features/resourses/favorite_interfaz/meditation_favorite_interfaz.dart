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
    await _seedMeditations(); // Inserta audios iniciales si no existen
    await _loadFavoritas();    // Carga favoritos desde la DB
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
      // Revertir si falla
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
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_favoritas.isEmpty) {
      return Scaffold(
        appBar: AppBar(
        title: const Text("Meditación y respiración"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.star_border_rounded, size: 64, color: Color(0xFFA0A5BC)),
              SizedBox(height: 12),
              Text(
                'No tienes meditaciones favoritas aún',
                style: TextStyle(
                  color: Color(0xFFA0A5BC),
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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
    final isCurrent = currentIndex == index;

    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        color: isCurrent ? Colors.blue[200] : Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCurrent && isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
                title: Text(audio.title_meditation),
                subtitle: Text(audio.descripcion_meditation),
                trailing: IconButton(
                  icon: Icon(
                    audio.favorite_meditation ? Icons.star : Icons.star_border,
                    color: audio.favorite_meditation ? Colors.yellow[700] : Colors.grey,
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
                                activeColor: Colors.blue,
                                inactiveColor: Colors.blue[100],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDuration(pos), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(_formatDuration(total), style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
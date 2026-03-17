import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/relaxing_audio_controller.dart';
import '../model/relaxing_audio_model.dart';

class RelaxingAudioScreen extends StatelessWidget {
  const RelaxingAudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RelaxingAudioController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8F1F8),
        title: const Text(
          'Audios relajantes',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE7D8F5),
        onPressed: () async {
          await controller.pickAndImportAudio();
        },
        child: const Icon(
          Icons.add,
          color: Colors.deepPurple,
        ),
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(RelaxingAudioController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.audios.isEmpty) {
      return const Center(
        child: Text(
          'No hay audios relajantes todavía.\nAñade uno con el botón +',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: controller.audios.length,
      itemBuilder: (context, index) {
        final audio = controller.audios[index];
        return _AudioCard(audio: audio);
      },
    );
  }
}

class _AudioCard extends StatelessWidget {
  final RelaxingAudioModel audio;

  const _AudioCard({required this.audio});

  @override
  Widget build(BuildContext context) {


    final controller = context.watch<RelaxingAudioController>();

    final bool isCurrentAudio = controller.currentPlayingAudioId == audio.id;
    final bool isPlayingCurrent = isCurrentAudio && controller.isPlaying;

    final Duration currentPosition =
    isCurrentAudio ? controller.currentPosition : Duration.zero;

    final Duration totalDuration = isCurrentAudio
        ? controller.totalDuration
        : Duration(seconds: audio.durationSeconds ?? 0);

    final double progress = isCurrentAudio ? controller.progressValue : 0.0;

    String _formatDurationFromDuration(Duration duration) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlayButton(
                isPlaying: isPlayingCurrent,
                onTap: () async {
                  await controller.togglePlay(audio);
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        audio.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF24314A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _buildSubtitle(audio),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B7A90),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  await controller.toggleFavorite(audio);
                },
                icon: Icon(
                  audio.isFavorite ? Icons.star : Icons.star_border,
                  color: audio.isFavorite
                      ? Colors.amber
                      : const Color(0xFF74839A),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  value: progress.clamp(0.0, 1.0),
                  onChanged: null, // por ahora solo visual, sin arrastrar
                  min: 0,
                  max: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDurationFromDuration(currentPosition),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7A90),
                      ),
                    ),
                    Text(
                      _formatDurationFromDuration(totalDuration),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7A90),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _buildSubtitle(RelaxingAudioModel audio) {
    final duration = _formatDuration(audio.durationSeconds);

    if (audio.fileName != null && audio.fileName!.trim().isNotEmpty) {
      return duration == '--:--'
          ? 'Audio local'
          : 'Audio local · $duration';
    }

    return duration == '--:--' ? 'Audio relajante' : 'Audio relajante · $duration';
  }

  String _formatDuration(int? totalSeconds) {
    if (totalSeconds == null || totalSeconds <= 0) {
      return '--:--';
    }

    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const _PlayButton({
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF6C9AD6),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 64,
          height: 64,
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }
}
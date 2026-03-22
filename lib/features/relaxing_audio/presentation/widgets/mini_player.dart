import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/relaxing_audio_controller.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RelaxingAudioController>();

    final audioId = controller.currentPlayingAudioId;

    if (audioId == null) return const SizedBox.shrink();

    final audio = controller.audios
        .firstWhere((a) => a.id == audioId, orElse: () => controller.audios.first);

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Play / Pause
              GestureDetector(
                onTap: () {
                  controller.togglePlay(audio);
                },
                child: Icon(
                  controller.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: 40,
                  color: const Color(0xFF6C9AD6),
                ),
              ),

              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(
                  audio.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Favorite
              IconButton(
                onPressed: () {
                  controller.toggleFavorite(audio);
                },
                icon: Icon(
                  audio.isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
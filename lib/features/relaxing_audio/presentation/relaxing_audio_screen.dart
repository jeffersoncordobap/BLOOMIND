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
      appBar: AppBar(
        title: const Text('Audios relajantes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.pickAndImportAudio();
        },
        child: const Icon(Icons.add),
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
        ),
      );
    }

    return ListView.builder(
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
    final controller = context.read<RelaxingAudioController>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.music_note),
        title: Text(audio.title),
        subtitle: Text(audio.fileName ?? ''),
        trailing: IconButton(
          icon: Icon(
            audio.isFavorite ? Icons.star : Icons.star_border,
            color: audio.isFavorite ? Colors.amber : null,
          ),
          onPressed: () {
            controller.toggleFavorite(audio);
          },
        ),
      ),
    );
  }
}
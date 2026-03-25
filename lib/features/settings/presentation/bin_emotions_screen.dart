import 'package:bloomind/features/emotions/model/emotion.dart';
import 'package:bloomind/features/settings/controller/bin_controller.dart';
import 'package:bloomind/features/emotions/controller/emotion_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnlyEmotionsRemovedScreen extends StatefulWidget {
  const OnlyEmotionsRemovedScreen({super.key});

  @override
  State<OnlyEmotionsRemovedScreen> createState() =>
      _OnlyEmotionRemovedScreenState();
}

class _OnlyEmotionRemovedScreenState extends State<OnlyEmotionsRemovedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BinController>().loadDeletedEmotions();
    });
  }

  void _showOptionsDialog(Emotion emotion) {
    final binController = context.read<BinController>();
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.restore_from_trash, color: colorScheme.primary),
              title: Text("Restaurar", style: TextStyle(color: colorScheme.onSurface)),
              onTap: () async {
                Navigator.pop(dialogContext);
                await binController.restoreEmotion(emotion.idEmotion!);

                if (mounted) {
                  context.read<EmotionController>().cargarTodosLosEventos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Emoción restaurada correctamente')),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: colorScheme.error),
              title: Text("Eliminar definitivamente", style: TextStyle(color: colorScheme.error)),
              onTap: () {
                Navigator.pop(dialogContext);
                binController.forceDeleteEmotion(emotion.idEmotion!);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BinController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        title: const Text("Papelera de emociones"),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Aquí puedes ver las emociones que has eliminado. Restáuralas si fue un error.",
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: colorScheme.primary),
                  )
                : controller.deletedEmotions.isEmpty
                    ? Center(
                        child: Text(
                          "No tienes emociones eliminadas",
                          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.deletedEmotions.length,
                        itemBuilder: (context, index) {
                          final emotion = controller.deletedEmotions[index];
                          return GestureDetector(
                            onLongPress: () => _showOptionsDialog(emotion),
                            child: _DeleteEmotionCard(emotion: emotion),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _DeleteEmotionCard extends StatelessWidget {
  final Emotion emotion;
  const _DeleteEmotionCard({super.key, required this.emotion});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji representativo
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(emotion.emoji, style: TextStyle(fontSize: 28, color: colorScheme.onSurface)),
          ),
          const SizedBox(width: 16),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emotion.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emotion.dateTime.split('T')[0],
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (emotion.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '"${emotion.note}"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Botón rápido de Restaurar
          IconButton(
            icon: Icon(
              Icons.restore_from_trash_rounded,
              color: colorScheme.secondary,
            ),
            tooltip: "Restaurar",
            onPressed: () async {
              await context.read<BinController>().restoreEmotion(emotion.idEmotion!);
              if (context.mounted) {
                context.read<EmotionController>().cargarTodosLosEventos();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Emoción restaurada')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
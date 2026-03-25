import 'package:flutter/material.dart';

class EmocionCard extends StatelessWidget {
  final String emoji;
  final String texto;
  final bool seleccionada;
  final VoidCallback onTap;

  const EmocionCard({
    super.key,
    required this.emoji,
    required this.texto,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorScheme.surface, // Antes Colors.white
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.05), // Antes black.withOpacity
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: seleccionada
              ? Border.all(color: colorScheme.primary, width: 2) // Antes Colors.pink
              : null,
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 32, color: colorScheme.onSurface)),
            const SizedBox(width: 20),
            Text(texto, style: TextStyle(fontSize: 18, color: colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
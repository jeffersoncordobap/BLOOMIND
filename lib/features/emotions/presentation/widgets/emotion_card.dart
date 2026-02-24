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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: seleccionada
              ? Border.all(color: Colors.pink, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 20),
            Text(texto, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

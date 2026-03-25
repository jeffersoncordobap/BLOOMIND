import 'package:flutter/material.dart';

class CategoriaCard extends StatelessWidget {
  final String emoji;
  final String nombre;
  final int count;
  final VoidCallback onTap;

  const CategoriaCard({
    super.key,
    required this.emoji,
    required this.nombre,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 45)),
              const SizedBox(height: 12),
              Text(
                nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count elementos',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

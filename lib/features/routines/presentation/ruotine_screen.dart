import 'package:flutter/material.dart';

class RoutineScreen extends StatelessWidget {
  final VoidCallback alPresionarListaRutinas;
  final VoidCallback alPresionarAsignarRutinas;
  final VoidCallback alPresionarVerRutinaDia;
  const RoutineScreen({
    super.key,
    required this.alPresionarListaRutinas,
    required this.alPresionarAsignarRutinas,
    required this.alPresionarVerRutinaDia,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutinas'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          children: [
            Container(
              child: const Text(
                "Aquí aparecerá la información...",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 23),

            _buildPrimaryButton(
              text: 'Ver rutina del día',
              onTap: alPresionarVerRutinaDia,
            ),

            const SizedBox(height: 18),

            _buildPrimaryButton(
              text: 'Asignar rutinas',
              onTap: alPresionarAsignarRutinas,
            ),

            const SizedBox(height: 18),

            _buildPrimaryButton(
              text: 'Ver mis rutinas',
              onTap: alPresionarListaRutinas,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4D86C7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

import 'package:bloomind/features/routines/presentation/assign_routines_screen.dart';
import 'package:bloomind/features/routines/presentation/routines_list_screen.dart';
import 'package:flutter/material.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  void _verRutinaDelDia() {
    print("Ejecutando: Ver rutina del día");
  }

  void _asignarRutinas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AssignRoutineScreen()),
    );
  }

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
              onTap: _verRutinaDelDia,
            ),

            const SizedBox(height: 18),

            _buildPrimaryButton(
              text: 'Asignar rutinas',
              onTap: () {
                _asignarRutinas(context);
              },
            ),

            const SizedBox(height: 18),

            _buildPrimaryButton(
              text: 'Ver mis rutinas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoutineListScreen(),
                  ),
                );
              },
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
        // AQUÍ es donde se "conecta" la acción
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/emotion_controller.dart';
import '../widgets/emotion_card.dart';
import 'package:bloomind/features/settings/controller/profile_controller.dart';

class RegistroEmocionalScreen extends StatefulWidget {
  final VoidCallback alPresionarDiario;
  const RegistroEmocionalScreen({super.key, required this.alPresionarDiario});

  @override
  State<RegistroEmocionalScreen> createState() =>
      _RegistroEmocionalScreenState();
}

class _RegistroEmocionalScreenState extends State<RegistroEmocionalScreen> {
  String? emocionSeleccionada;

  final List<Map<String, String>> emociones = [
    {'emoji': '😄', 'texto': 'Feliz'},
    {'emoji': '🥱', 'texto': 'Cansado'},
    {'emoji': '😢', 'texto': 'Triste'},
    {'emoji': '😡', 'texto': 'Enojado'},
    {'emoji': '😓', 'texto': 'Desmotivado'},
    {'emoji': '😐', 'texto': 'Neutral'},
  ];

  @override
  Widget build(BuildContext context) {
    final emotionProvider = context.read<EmotionController>();
    final profileController = Provider.of<ProfileController>(context);
    final perfil = profileController.profile;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Registro emocional",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Perfil
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(perfil.emoji,
                          style: TextStyle(fontSize: 28, color: colorScheme.onSurface)),
                      const SizedBox(width: 10),
                      Text(
                        perfil.nombre.isEmpty
                            ? "Bienvenido/a"
                            : "Hola, ${perfil.nombre}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "¿Cómo te sientes en este momento?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),

                // Emojis
                ...emociones.map((emocion) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: EmocionCard(
                      emoji: emocion['emoji']!,
                      texto: emocion['texto']!,
                      seleccionada: emocionSeleccionada == emocion['texto'],
                      onTap: () {
                        setState(() {
                          emocionSeleccionada = emocion['texto'];
                        });
                      },
                    ),
                  );
                }).toList(),

                // Texto adicional + botón
                if (emocionSeleccionada != null) ...[
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Cuéntame más",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: emotionProvider.notaController,
                        maxLines: 4,
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: "¿Qué pasó hoy? (opcional)",
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        bool exito = await emotionProvider.guardarEmocion(
                          emocionSeleccionada,
                        );
                        if (exito) {
                          setState(() => emocionSeleccionada = null);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Guardado con éxito!'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Guardar registro",
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                // Ver diario
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                    onPressed: widget.alPresionarDiario,
                    child: Text(
                      "Ver mi diario",
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
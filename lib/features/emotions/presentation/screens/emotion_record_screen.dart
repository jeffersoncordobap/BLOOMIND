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
      // Usamos el color de fondo del tema (que es el gris azulado en modo claro)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                // --- HEADER ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: colorScheme.surface, // Blanco puro en modo claro
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Registro emocional",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // --- TARJETA DE PERFIL (Diferenciada del fondo) ---
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme
                        .surface, // Blanco para contrastar con el fondo
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          perfil.emoji.isEmpty ? "😊" : perfil.emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          perfil.nombre.isEmpty
                              ? "Bienvenido/a"
                              : "Hola, ${perfil.nombre}",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: 18,
                                color: colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "¿Cómo te sientes en este momento?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 20),

                // --- LISTADO DE EMOCIONES ---
                ...emociones.map((emocion) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
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

                // --- SECCIÓN DE NOTA Y GUARDADO ---
                if (emocionSeleccionada != null) ...[
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Cuéntame más",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: emotionProvider.notaController,
                        maxLines: 4,
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: "¿Qué pasó hoy? (opcional)",
                          contentPadding: const EdgeInsets.all(18),
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.4),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
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
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 58),
                        elevation: 2,
                        shadowColor: colorScheme.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Guardar registro",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 25),

                // --- BOTÓN VER DIARIO ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: colorScheme.surface.withOpacity(0.5),
                      minimumSize: const Size(double.infinity, 55),
                      side: BorderSide(
                        color: colorScheme.outline.withOpacity(0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: widget.alPresionarDiario,
                    child: Text(
                      "Ver mi diario",
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
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

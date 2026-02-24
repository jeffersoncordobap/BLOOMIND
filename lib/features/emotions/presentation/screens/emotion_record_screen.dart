import 'package:flutter/material.dart';
import '../../controller/emotion_controller.dart';
import '../widgets/emotion_card.dart';

class RegistroEmocionalScreen extends StatefulWidget {
  const RegistroEmocionalScreen({super.key});

  @override
  State<RegistroEmocionalScreen> createState() =>
      _RegistroEmocionalScreenState();
}

class _RegistroEmocionalScreenState extends State<RegistroEmocionalScreen> {
  String? emocionSeleccionada;

  final EmotionController _controller = EmotionController();

  final List<Map<String, String>> emociones = [
    {'emoji': '😄', 'texto': 'Feliz'},
    {'emoji': '🥱', 'texto': 'Cansado'},
    {'emoji': '😢', 'texto': 'Triste'},
    {'emoji': '😡', 'texto': 'Enojado'},
    {'emoji': '😓', 'texto': 'Desmotivado'},
    {'emoji': '😐', 'texto': 'Neutral'},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Registro emocional",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE7F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text("😊", style: TextStyle(fontSize: 28)),
                      SizedBox(width: 10),
                      Text("Bienvenido/a", style: TextStyle(fontSize: 18)),
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

                if (emocionSeleccionada != null) ...[
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Cuéntame más",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _controller.notaController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: "¿Qué pasó hoy? (opcional)",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      // 5. IMPLEMENTA LA LÓGICA DE GUARDADO
                      onPressed: () async {
                        bool exito = await _controller.guardarEmocion(
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
                        backgroundColor: const Color(0xFF5F8FBF),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Guardar registro",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      //navegar a la pantalla del historial
                    },
                    child: const Text("Ver mi diario"),
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

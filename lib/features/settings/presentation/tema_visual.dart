import 'package:bloomind/features/settings/model/tema.dart';
import 'package:bloomind/features/settings/presentation/tema_controller.dart';
import 'package:bloomind/features/settings/repository/settings_tema_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/settings_tema_repository.dart';

class TemaVisualScreen extends StatefulWidget {
  const TemaVisualScreen({super.key});

  @override
  State<TemaVisualScreen> createState() => TemaVisualScreenState();
}

class TemaVisualScreenState extends State<TemaVisualScreen> {
  bool modoOscuro = false; 
  final ConfigTemasRepository _temasRepository = ConfigTemasRepositoryImpl();

    @override
  void initState() {
    super.initState();
    cambiar_tema(); // ver tema actual y cambiarlo
  }

void cambiar_tema() async {
  final ConfigTemas? temasGuardado = await _temasRepository.getTema(); 
  setState(() {
  modoOscuro = temasGuardado?.bool_tema ?? false; 
  });
}


@override
Widget build(BuildContext context) {
  final temaProvider = Provider.of<TemaProvider>(context); // listen: true por defecto

  return Scaffold(
    backgroundColor:
        temaProvider.modoOscuro ? const Color(0xFF0F172A) : const Color(0xFFE5E7EB),
    appBar: AppBar(
      backgroundColor:
          temaProvider.modoOscuro ? const Color(0xFF1E293B) : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: temaProvider.modoOscuro ? Colors.white : Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Tema visual',
        style: TextStyle(
          color: temaProvider.modoOscuro ? Colors.white : Colors.black,
        ),
      ),
      centerTitle: true,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              temaProvider.cambiarTema(false);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: temaProvider.modoOscuro
                    ? const Color(0xFF334155)
                    : const Color(0xFF5E8DB8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Text("☀️", style: TextStyle(fontSize: 32)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Modo claro",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Colores suaves y brillantes",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              temaProvider.cambiarTema(true);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: temaProvider.modoOscuro
                    ? const Color(0xFF5E8DB8)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text("🌙", style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Modo oscuro",
                          style: TextStyle(
                            color: temaProvider.modoOscuro
                                ? Colors.white
                                : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Reduce el brillo de la pantalla",
                          style: TextStyle(
                            color: temaProvider.modoOscuro
                                ? Colors.white70
                                : Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
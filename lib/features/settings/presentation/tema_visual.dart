import 'package:bloomind/features/settings/model/tema.dart';
import 'package:bloomind/features/settings/controller/tema_controller.dart';
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
    final temaProvider = Provider.of<TemaProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: const Text('Tema visual'),
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
                  color: !temaProvider.modoOscuro
                      ? colorScheme.primary
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outline),
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
                      ? colorScheme.primary
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outline),
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

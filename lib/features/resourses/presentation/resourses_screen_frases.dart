import 'package:bloomind/features/resourses/model/phrase.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import "../repository/resourse_repository.dart";
import '../repository/resourse_repository_impl.dart';
import '../contenido/frases_data.dart';

class ResoursesScreenFrases extends StatefulWidget {
  const ResoursesScreenFrases({super.key});

  @override
  State<ResoursesScreenFrases> createState() => ResoursesScreenFrasesState();
}

class ResoursesScreenFrasesState extends State<ResoursesScreenFrases> {
  final ResourseRepository _repository = ResourseRepositoryImpl();
  List<ResourseFrases> frasesDB = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _cargarFrases();
  }

  void refreshFrases() async {
    frasesDB = await _repository.getAllFrases();
    setState(() {});
  }

  Future<void> _cargarFrases() async {
    final frasesIniciales = frasesMotivacionales;
    final frasesExistentes = await _repository.getAllFrases();

    for (String frase in frasesIniciales) {
      bool existe = frasesExistentes.any((f) => f.contenido_frases == frase);
      if (!existe) {
        await _repository.createFrases(
          ResourseFrases(contenido_frases: frase, favorita_frase: false),
        );
      }
    }

    frasesDB = await _repository.getAllFrases();
    setState(() {});
  }

  void changeFrase() {
    setState(() {
      if (frasesDB.isNotEmpty) {
        currentIndex = (currentIndex + 1) % frasesDB.length;
      }
    });
  }

  void toggleFavorite() async {
    if (frasesDB.isEmpty) return;

    ResourseFrases fraseActual = frasesDB[currentIndex];
    ResourseFrases updated = ResourseFrases(
      id_frases: fraseActual.id_frases,
      contenido_frases: fraseActual.contenido_frases,
      favorita_frase: !fraseActual.favorita_frase,
    );

    await _repository.updateFrase(updated);
    frasesDB[currentIndex] = updated;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Frases Motivacionales'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(2);
          },
        ),
        elevation: 0,
      ),
      body: frasesDB.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.onSurface.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          frasesDB[currentIndex].contenido_frases,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: toggleFavorite,
                          child: Icon(
                            frasesDB[currentIndex].favorita_frase
                                ? Icons.star
                                : Icons.star_border,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: changeFrase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Cambiar frase",
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
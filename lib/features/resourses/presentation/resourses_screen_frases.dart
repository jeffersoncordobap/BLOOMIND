import 'package:bloomind/features/resourses/model/phrase.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import "../repository/resourse_repository.dart";
import '../repository/resourse_repository_impl.dart';
import '../contenido/frases_data.dart';
//import '../controller/resourse_controller.dart';

class ResoursesScreenFrases extends StatefulWidget {
  const ResoursesScreenFrases({super.key});

  @override
  State<ResoursesScreenFrases> createState() => _ResoursesScreenFrasesState();
}

class _ResoursesScreenFrasesState extends State<ResoursesScreenFrases> {
  final ResourseRepository _repository = ResourseRepositoryImpl();

  List<ResourseFrases> frasesDB = []; // Lista cargada desde la DB
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _cargarFrases(); // Cargar y mostrar frases
  }

  Future<void> _cargarFrases() async {
    // Primero insertamos las frases iniciales si no existen
    print("Cargando frases en DB...");
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

    // Luego cargamos todas las frases desde la DB
    frasesDB = await _repository.getAllFrases();
    setState(() {}); // Actualiza la UI
    print("Frases cargadas: ${frasesDB.length}");
  }

  //Cambia la frase
  void changeFrase() {
    setState(() {
      if (frasesDB.isNotEmpty) {
        currentIndex = (currentIndex + 1) % frasesDB.length;
      }
    });
  }

  //Marca la frase favorita
  void toggleFavorite() async {
    if (frasesDB.isEmpty) return;

    ResourseFrases fraseActual = frasesDB[currentIndex];

    // Cambiamos el estado de favorita
    ResourseFrases updated = ResourseFrases(
      id_frases: fraseActual.id_frases,
      contenido_frases: fraseActual.contenido_frases,
      favorita_frase: !fraseActual.favorita_frase,
    );

    await _repository.updateFrase(updated); // Guardamos en DB

    // Actualizamos la lista local y refrescamos UI
    frasesDB[currentIndex] = updated;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frases Motivacionales'),
        centerTitle: true,
        backgroundColor: const Color(0xFF4D86C7),
        //Importante: puedes usar esta funcion, para cambiar entre ventanas
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(2);
          },
        ),
      ),
      body: frasesDB.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            ) // espera a que cargue
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
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          frasesDB[currentIndex].contenido_frases,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
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
                            color: Colors.amber,
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
                        backgroundColor: const Color(0xFF4D86C7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Cambiar frase",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

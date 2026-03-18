//Codigo de la pantalla recursos
import 'package:bloomind/features/resourses/presentation/resourses_screen_favorito.dart';
import 'package:bloomind/features/resourses/presentation/support_lines_screen.dart';
import 'package:flutter/material.dart';

//import './/resourses_screen_frases.dart';
//import './/resourses_screen_meditacion.dart';

class RecurseScreen extends StatelessWidget {
  final VoidCallback alPresionarMeditacionRespiracion;
  final VoidCallback alPresionarResoursesScreenFrases;
  final VoidCallback alPresionarResoursesScreenAudios;
  final VoidCallback alPresionarResoursesScreenSorpresa;

  const RecurseScreen({
    super.key,
    required this.alPresionarMeditacionRespiracion,
    required this.alPresionarResoursesScreenFrases,
    required this.alPresionarResoursesScreenAudios,
    required this.alPresionarResoursesScreenSorpresa,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Recursos"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tarjeta superior
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE6F1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Acceso personalizado",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "😊 Tu centro de recursos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Guarda tus favoritos y vuelve rápido a lo que más te ayuda.",
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tarjeta Meditación
              InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: alPresionarMeditacionRespiracion,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text("🧘", style: TextStyle(fontSize: 30)),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Meditación y respiración",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tarjeta Frases y motivación
              InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: alPresionarResoursesScreenFrases,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text("☁️", style: TextStyle(fontSize: 30)),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Frases y motivación",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tarjeta Audios Relajantes
              InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: alPresionarResoursesScreenAudios,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text("🎧", style: TextStyle(fontSize: 30)),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Audios relajantes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tarjeta Actividad sorpresa
              InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: alPresionarResoursesScreenSorpresa,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text("🎁", style: TextStyle(fontSize: 30)),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Actividad sorpresa",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tarjeta Líneas de apoyo
              InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SupportLinesScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text("❤️", style: TextStyle(fontSize: 30)),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Líneas de apoyo",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Favoritos
              InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritosScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text("⭐", style: TextStyle(fontSize: 30)),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Favoritos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
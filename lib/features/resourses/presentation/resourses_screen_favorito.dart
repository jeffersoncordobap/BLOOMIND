import 'package:flutter/material.dart';
import '../repository/resourse_repository.dart';
import '../repository/resourse_repository_impl.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository_impl.dart';
import 'package:bloomind/features/resourses/presentation/favoritos_sorpresa_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final ResourseRepository _repository = ResourseRepositoryImpl();
  final _surpriseRepo = SurpriseActivityRepositoryImpl();
  int _frasesFavoritas = 0;
  int _actividadesFavoritas = 0;

  @override
  void initState() {
    super.initState();
    _cargarContadores();
  }

  Future<void> _cargarContadores() async {
    final frases = await _repository.getAllFrases();
    final actividades = await _surpriseRepo.countFavoritos();
    if (mounted) {
      setState(() {
        _frasesFavoritas = frases.where((f) => f.favorita_frase).length;
        _actividadesFavoritas = actividades;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7), // Fondo que ya tenías
      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          // Cambiamos a ListView para tarjetas individuales y controladas
          children: [
            // 1. MEDITACIÓN
            _CardFavorito(
              emoji: '🧘',
              nombre: 'Meditación y respiración',
              count: 0,
              onTap: () {
                // COMPAÑERO A: Conecta aquí tu pantalla
                print("Navegando a Meditación...");
              },
            ),
            const SizedBox(height: 12),

            // 2. FRASES
            _CardFavorito(
              emoji: '☁️',
              nombre: 'Frases y motivación',
              count: 0,
              onTap: () {
                // COMPAÑERO B: Conecta aquí tu pantalla
                print("Navegando a Frases...");
              },
            ),
            const SizedBox(height: 12),

            // 3. AUDIOS
            _CardFavorito(
              emoji: '🎧',
              nombre: 'Audios relajantes',
              count: 0,
              onTap: () {
                // COMPAÑERO C: Conecta aquí tu pantalla
                print("Navegando a Audios...");
              },
            ),
            const SizedBox(height: 12),

            // 4. Actividades sorpresa
            _CardFavorito(
              emoji: '🎁',
              nombre: 'Actividades sorpresa',
              count: _actividadesFavoritas,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritosSorpresaScreen(),
                  ),
                ).then((_) => _cargarContadores());
              },
            ),
            const SizedBox(height: 12),

            // 5. LÍNEAS DE APOYO
            _CardFavorito(
              emoji: '❤️',
              nombre: 'Líneas de apoyo',
              count: 0,
              onTap: () {
                // COMPAÑERO E: Conecta aquí tu pantalla
                print("Navegando a Líneas de Apoyo...");
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget privado para mantener el estilo visual y la funcionalidad táctil
class _CardFavorito extends StatelessWidget {
  final String emoji;
  final String nombre;
  final int count;
  final VoidCallback onTap;

  const _CardFavorito({
    required this.emoji,
    required this.nombre,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        // Material e InkWell para el efecto visual al tocar
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$count favorito${count == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

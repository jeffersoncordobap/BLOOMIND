import 'package:flutter/material.dart';
import '../repository/resourse_repository.dart';
import '../repository/resourse_repository_impl.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final ResourseRepository _repository = ResourseRepositoryImpl();
  int _frasesFavoritas = 0;

  @override
  void initState() {
    super.initState();
    _cargarContadores();
  }

  Future<void> _cargarContadores() async {
    final frases = await _repository.getAllFrases();
    setState(() {
      _frasesFavoritas = frases.where((f) => f.favorita_frase).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categorias = [
      {'emoji': '🧘', 'nombre': 'Meditación y respiración', 'count': 0},
      {'emoji': '☁️', 'nombre': 'Frases y motivación', 'count': _frasesFavoritas},
      {'emoji': '🎧', 'nombre': 'Audios relajantes', 'count': 0},
      {'emoji': '🎁', 'nombre': 'Actividad sorpresa', 'count': 0},
      {'emoji': '❤️', 'nombre': 'Líneas de apoyo', 'count': 0},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView.separated(
          itemCount: categorias.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final cat = categorias[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  Text(cat['emoji'] as String, style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['nombre'] as String,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cat['count']} favorito${(cat['count'] as int) == 1 ? '' : 's'}',
                          style: const TextStyle(fontSize: 13, color: Colors.black38),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

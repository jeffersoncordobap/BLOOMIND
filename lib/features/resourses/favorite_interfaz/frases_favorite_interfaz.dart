import 'package:flutter/material.dart';
import '../model/phrase.dart';
import '../repository/resourse_repository.dart';
import '../repository/resourse_repository_impl.dart';
import '../contenido/frases_data.dart'; // tu lista de frases iniciales

class FavoritasFrasesScreen extends StatefulWidget {
  const FavoritasFrasesScreen({super.key});

  @override
  State<FavoritasFrasesScreen> createState() => _FavoritasFrasesScreenState();
}

class _FavoritasFrasesScreenState extends State<FavoritasFrasesScreen> {
  final ResourseRepository _repository = ResourseRepositoryImpl();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<ResourseFrases> _favoritas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarFavoritas();
  }

  Future<void> _cargarFavoritas() async {
    try {
      //  Inserta frases iniciales si no existen
      final frasesExistentes = await _repository.getAllFrases();
      for (String frase in frasesMotivacionales) {
        bool existe = frasesExistentes.any((f) => f.contenido_frases == frase);
        if (!existe) {
          await _repository.createFrases(
            ResourseFrases(contenido_frases: frase, favorita_frase: false),
          );
        }
      }

      //  Carga todas las frases y filtra solo las favoritas
      final todas = await _repository.getAllFrases();
      setState(() {
        _favoritas = todas.where((f) => f.favorita_frase).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Error cargando favoritas: $e");
    }
  }

  Future<void> _quitarFavorita(int index) async {
    final frase = _favoritas[index];

    // Animación: primero removemos de AnimatedList
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildCard(frase, index, animation),
      duration: const Duration(milliseconds: 300),
    );

    _favoritas.removeAt(index);

    try {
      final updated = ResourseFrases(
        id_frases: frase.id_frases,
        contenido_frases: frase.contenido_frases,
        favorita_frase: false,
      );
      await _repository.updateFrase(updated);
    } catch (e) {
      // Revertir si falla
      setState(() {
        _favoritas.insert(index, frase);
        _listKey.currentState?.insertItem(index);
      });
      debugPrint("Error actualizando DB: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text("Meditación y respiración"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return _buildSkeletons();
    if (_favoritas.isEmpty) return _buildEmpty();

    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      initialItemCount: _favoritas.length,
      itemBuilder: (context, index, animation) {
        return _buildCard(_favoritas[index], index, animation);
      },
    );
  }

  Widget _buildCard(ResourseFrases frase, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '"${frase.contenido_frases}"',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF1A1D2E),
                      height: 1.55,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _quitarFavorita(index),
                  child: Icon(
                    frase.favorita_frase ? Icons.star : Icons.star_border,
                    color: frase.favorita_frase ? Colors.amber[700] : Colors.grey[400],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border_rounded, size: 64, color: Color(0xFFA0A5BC)),
          SizedBox(height: 12),
          Text(
            'No tienes frases favoritas aún',
            style: TextStyle(
              color: Color(0xFFA0A5BC),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletons() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: 3,
      itemBuilder: (_, __) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[200], borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 8),
              Container(
                  height: 10,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[200], borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 8),
              Container(
                  height: 10,
                  width: 140,
                  decoration: BoxDecoration(
                      color: Colors.grey[200], borderRadius: BorderRadius.circular(6))),
            ],
          ),
        ),
      ),
    );
  }
}
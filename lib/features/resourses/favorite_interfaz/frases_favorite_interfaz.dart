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
      // Inserta frases iniciales si no existen
      final frasesExistentes = await _repository.getAllFrases();
      for (String frase in frasesMotivacionales) {
        bool existe = frasesExistentes.any((f) => f.contenido_frases == frase);
        if (!existe) {
          await _repository.createFrases(
            ResourseFrases(contenido_frases: frase, favorita_frase: false),
          );
        }
      }

      // Carga todas las frases y filtra solo las favoritas
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

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildCard(frase, index, animation, Theme.of(context).colorScheme),
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
      setState(() {
        _favoritas.insert(index, frase);
        _listKey.currentState?.insertItem(index);
      });
      debugPrint("Error actualizando DB: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("Frases Favoritas"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildBody(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    if (_loading) return _buildSkeletons(colorScheme);
    if (_favoritas.isEmpty) return _buildEmpty(colorScheme);

    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      initialItemCount: _favoritas.length,
      itemBuilder: (context, index, animation) {
        return _buildCard(_favoritas[index], index, animation, Theme.of(context).colorScheme);
      },
    );
  }

  Widget _buildCard(
      ResourseFrases frase, int index, Animation<double> animation, ColorScheme colorScheme) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '"${frase.contenido_frases}"',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface,
                      height: 1.55,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _quitarFavorita(index),
                  child: Icon(
                    frase.favorita_frase ? Icons.star : Icons.star_border,
                    color: frase.favorita_frase
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
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

  Widget _buildEmpty(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border_rounded, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'No tienes frases favoritas aún',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletons(ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: 3,
      itemBuilder: (_, __) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        color: colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 8),
              Container(
                  height: 10,
                  width: 200,
                  decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 8),
              Container(
                  height: 10,
                  width: 140,
                  decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6))),
            ],
          ),
        ),
      ),
    );
  }
}
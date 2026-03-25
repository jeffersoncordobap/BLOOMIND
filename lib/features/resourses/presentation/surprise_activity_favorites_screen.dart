import 'package:bloomind/features/resourses/model/surprise_activity.dart';
import 'package:bloomind/features/resourses/presentation/surprise_activity_trash_screen.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository_impl.dart';
import 'package:flutter/material.dart';

class SurpriseActivityFavoritesScreen extends StatefulWidget {
  final Function? onFavoritosUpdated;
  
  const SurpriseActivityFavoritesScreen({super.key, this.onFavoritosUpdated});

  @override
  State<SurpriseActivityFavoritesScreen> createState() =>
      _SurpriseActivityFavoritesScreenState();
}

class _SurpriseActivityFavoritesScreenState
    extends State<SurpriseActivityFavoritesScreen> {
  final SurpriseActivityRepository _repo = SurpriseActivityRepositoryImpl();
  List<SurpriseActivity> _favoritos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    setState(() {
      _isLoading = true;
    });

    _favoritos = await _repo.getFavoritos();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _moverAPapelera(SurpriseActivity activity) async {
    if (activity.id == null) return;
    await _repo.moverAPapelera(activity.id!);
    await _cargarFavoritos();
    // Notificar cambios a sorpresa
    widget.onFavoritosUpdated?.call();
  }

  void _abrirPapelera() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurpriseActivityTrashScreen(
          onTrashUpdated: widget.onFavoritosUpdated,
        ),
      ),
    );
    await _cargarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF4FB),
      appBar: AppBar(
        title: const Text(
          'Actividades favoritas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF4A90D9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: 'Papelera',
            onPressed: _abrirPapelera,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoritos.isEmpty
          ? const Center(
              child: Text('No hay actividades sorpresa favoritas aún.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoritos.length,
              itemBuilder: (context, index) {
                final actividad = _favoritos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(actividad.description),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 26,
                      ),
                      tooltip: 'Mover a papelera',
                      onPressed: () => _moverAPapelera(actividad),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

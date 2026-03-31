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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Actividades favoritas',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Papelera',
            onPressed: _abrirPapelera,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _favoritos.isEmpty
          ? Center(
              child: Text(
                'No hay actividades sorpresa favoritas aún.',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoritos.length,
              itemBuilder: (context, index) {
                final actividad = _favoritos[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  color: colorScheme.surfaceContainerLow,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    title: Text(
                      actividad.description,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28,
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

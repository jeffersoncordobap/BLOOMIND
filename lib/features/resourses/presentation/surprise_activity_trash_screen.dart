import 'package:bloomind/features/resourses/model/surprise_activity.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository_impl.dart';
import 'package:flutter/material.dart';

class SurpriseActivityTrashScreen extends StatefulWidget {
  final Function? onTrashUpdated;

  const SurpriseActivityTrashScreen({super.key, this.onTrashUpdated});

  @override
  State<SurpriseActivityTrashScreen> createState() =>
      _SurpriseActivityTrashScreenState();
}

class _SurpriseActivityTrashScreenState
    extends State<SurpriseActivityTrashScreen> {
  final SurpriseActivityRepository _repo = SurpriseActivityRepositoryImpl();
  List<SurpriseActivity> _trash = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshTrash();
  }

  Future<void> _refreshTrash() async {
    setState(() {
      _isLoading = true;
    });

    _trash = await _repo.getPapelera();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _restore(SurpriseActivity activity) async {
    if (activity.id == null) return;
    await _repo.restaurarDePapelera(activity.id!);
    await _refreshTrash();
    widget.onTrashUpdated?.call();
  }

  Future<void> _deletePermanent(SurpriseActivity activity) async {
    if (activity.id == null) return;
    await _repo.eliminarPermanentemente(activity.id!);
    await _refreshTrash();
    widget.onTrashUpdated?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Papelera de actividades',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _trash.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🗑️', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text(
                    'No hay actividades en la papelera',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _trash.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final activity = _trash[index];
                return Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.description,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Será eliminado en ${activity.diasRestantes} días',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restore_from_trash),
                          color: Colors.greenAccent[700],
                          tooltip: 'Restaurar',
                          onPressed: () => _restore(activity),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever),
                          color: colorScheme.error,
                          tooltip: 'Eliminar permanentemente',
                          onPressed: () => _deletePermanent(activity),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

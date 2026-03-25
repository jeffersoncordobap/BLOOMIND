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
    // Notificar cambios
    widget.onTrashUpdated?.call();
  }

  Future<void> _deletePermanent(SurpriseActivity activity) async {
    if (activity.id == null) return;
    await _repo.eliminarPermanentemente(activity.id!);
    await _refreshTrash();
    // Notificar cambios
    widget.onTrashUpdated?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papelera de actividades'),
        backgroundColor: const Color(0xFF4A90D9),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trash.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🗑️', style: TextStyle(fontSize: 60)),
                  SizedBox(height: 16),
                  Text(
                    'No hay actividades en la papelera',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x224A90D9),
                        blurRadius: 8,
                        offset: Offset(0, 3),
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
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Será eliminado en ${activity.diasRestantes} días',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.restore_from_trash,
                            color: Colors.green,
                          ),
                          tooltip: 'Restaurar',
                          onPressed: () => _restore(activity),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
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

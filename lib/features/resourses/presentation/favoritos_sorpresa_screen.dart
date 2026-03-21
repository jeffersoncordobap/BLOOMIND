import 'package:bloomind/features/resourses/model/surprise_activity.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository_impl.dart';
import 'package:flutter/material.dart';

class FavoritosSorpresaScreen extends StatefulWidget {
  const FavoritosSorpresaScreen({super.key});

  @override
  State<FavoritosSorpresaScreen> createState() => _FavoritosSorpresaScreenState();
}

class _FavoritosSorpresaScreenState extends State<FavoritosSorpresaScreen> {
  final _repo = SurpriseActivityRepositoryImpl();
  List<SurpriseActivity> _favoritos = [];

  @override
  void initState() {
    super.initState();
    _repo.limpiarPapeleraExpirada().then((_) => _cargar());
  }

  Future<void> _cargar() async {
    final lista = await _repo.getFavoritos();
    if (!mounted) return;
    setState(() => _favoritos = lista);
  }

  Future<void> _moverAPapelera(SurpriseActivity actividad) async {
    await _repo.moverAPapelera(actividad.id!);
    setState(() => _favoritos.removeWhere((a) => a.id == actividad.id));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Movido a la papelera. Se eliminará en 7 días.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _abrirPapelera() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _PapeleraScreen(repo: _repo)),
    ).then((_) => _cargar());
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
      body: _favoritos.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('⭐', style: TextStyle(fontSize: 60)),
                  SizedBox(height: 16),
                  Text(
                    'Aún no tienes actividades favoritas',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _favoritos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final actividad = _favoritos[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x224A90D9),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    title: Text(
                      actividad.description,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.star,
                          color: Colors.amber, size: 26),
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

class _PapeleraScreen extends StatefulWidget {
  final SurpriseActivityRepositoryImpl repo;
  const _PapeleraScreen({required this.repo});

  @override
  State<_PapeleraScreen> createState() => _PapeleraScreenState();
}

class _PapeleraScreenState extends State<_PapeleraScreen> {
  List<SurpriseActivity> _papelera = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await widget.repo.getPapelera();
    if (!mounted) return;
    setState(() => _papelera = lista);
  }

  Future<void> _restaurar(SurpriseActivity actividad) async {
    await widget.repo.restaurarDePapelera(actividad.id!);
    setState(() => _papelera.removeWhere((a) => a.id == actividad.id));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restaurado a favoritos ⭐')),
    );
  }

  Future<void> _eliminarPermanentemente(SurpriseActivity actividad) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar permanentemente'),
        content: const Text(
            '¿Seguro? Esta actividad ya no estará en tus favoritos.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar',
                  style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (confirmar != true) return;
    await widget.repo.eliminarPermanentemente(actividad.id!);
    setState(() => _papelera.removeWhere((a) => a.id == actividad.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF4FB),
      appBar: AppBar(
        title: const Text(
          'Papelera',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF4A90D9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _papelera.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🗑️', style: TextStyle(fontSize: 60)),
                  SizedBox(height: 16),
                  Text(
                    'Papelera vacía',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Las actividades eliminadas aparecerán aquí\ndurante 7 días.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _papelera.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final actividad = _papelera[index];
                final dias = actividad.diasRestantes;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x224A90D9),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    title: Text(
                      actividad.description,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      dias == 0
                          ? 'Se elimina hoy'
                          : 'Se elimina en $dias día${dias == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: dias <= 2 ? Colors.redAccent : Colors.black45,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restore,
                              color: Color(0xFF4A90D9), size: 24),
                          tooltip: 'Restaurar a favoritos',
                          onPressed: () => _restaurar(actividad),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.redAccent, size: 24),
                          tooltip: 'Eliminar permanentemente',
                          onPressed: () => _eliminarPermanentemente(actividad),
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

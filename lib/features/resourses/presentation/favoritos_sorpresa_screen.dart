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
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await _repo.getFavoritos();
    if (!mounted) return;
    setState(() => _favoritos = lista);
  }

  Future<void> _quitarFavorito(SurpriseActivity actividad) async {
    await _repo.toggleFavorito(actividad.id!, false);
    setState(() => _favoritos.removeWhere((a) => a.id == actividad.id));
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
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.star, color: Colors.amber, size: 28),
                      tooltip: 'Quitar de favoritos',
                      onPressed: () => _quitarFavorito(actividad),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

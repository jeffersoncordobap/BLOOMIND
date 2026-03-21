import 'package:bloomind/features/resourses/model/surprise_activity.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository_impl.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ResoursesScreenSorpresa extends StatefulWidget {
  const ResoursesScreenSorpresa({super.key});

  @override
  State<ResoursesScreenSorpresa> createState() => _ResoursesScreenSorpresaState();
}

class _ResoursesScreenSorpresaState extends State<ResoursesScreenSorpresa>
    with SingleTickerProviderStateMixin {
  bool mostrarRuleta = false;
  SurpriseActivity? actividadSeleccionada;
  bool girando = false;
  late AnimationController _controller;
  List<SurpriseActivity> actividades = [];
  final _repo = SurpriseActivityRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _cargarActividades();
  }

  Future<void> _cargarActividades() async {
    final lista = await _repo.getAll();
    if (!mounted) return;
    setState(() {
      actividades = lista;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void girarRuleta() {
    if (actividades.isEmpty) return;
    setState(() {
      girando = true;
      actividadSeleccionada = null;
    });

    _controller.reset();
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        actividadSeleccionada = actividades[Random().nextInt(actividades.length)];
        girando = false;
      });
    });
  }

  Future<void> _toggleFavorito() async {
    if (actividadSeleccionada == null) return;
    final nuevaActividad = SurpriseActivity(
      id: actividadSeleccionada!.id,
      description: actividadSeleccionada!.description,
      isFavorite: !actividadSeleccionada!.isFavorite,
    );
    await _repo.toggleFavorito(actividadSeleccionada!.id!, nuevaActividad.isFavorite);
    final index = actividades.indexWhere((a) => a.id == actividadSeleccionada!.id);
    if (!mounted) return;
    setState(() {
      actividades[index] = nuevaActividad;
      actividadSeleccionada = nuevaActividad;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF4FB),
      appBar: AppBar(
        title: const Text(
          'Actividad sorpresa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF4A90D9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(2);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: !mostrarRuleta
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4A90D9), Color(0xFF7BB8F0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x334A90D9),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '¿Necesitas inspiración para tu día?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Deja que te sugiera una actividad que puede mejorar tu bienestar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          mostrarRuleta = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90D9),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sorpréndeme',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF4A90D9), width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x334A90D9),
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          )
                        ],
                      ),
                      child: Center(
                        child: girando
                            ? RotationTransition(
                                turns: _controller,
                                child: const Text(
                                  '🎁',
                                  style: TextStyle(fontSize: 80),
                                ),
                              )
                            : actividadSeleccionada == null
                                ? const Text(
                                    '🎁',
                                    style: TextStyle(fontSize: 80),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      actividadSeleccionada!.description,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (actividadSeleccionada != null && !girando)
                      GestureDetector(
                        onTap: _toggleFavorito,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              actividadSeleccionada!.isFavorite
                                  ? Icons.star
                                  : Icons.star_border,
                              color: actividadSeleccionada!.isFavorite
                                  ? Colors.amber
                                  : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              actividadSeleccionada!.isFavorite
                                  ? 'Guardado en favoritos'
                                  : 'Agregar a favoritos',
                              style: TextStyle(
                                fontSize: 14,
                                color: actividadSeleccionada!.isFavorite
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: girando ? null : girarRuleta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90D9),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        actividadSeleccionada == null ? 'Girar' : 'Girar de nuevo',
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

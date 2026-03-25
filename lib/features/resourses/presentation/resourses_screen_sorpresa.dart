import 'package:bloomind/features/resourses/model/surprise_activity.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository.dart';
import 'package:bloomind/features/resourses/repository/surprise_activity_repository_impl.dart';
import 'package:bloomind/features/resourses/presentation/surprise_activity_favorites_screen.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';

class ResoursesScreenSorpresa extends StatefulWidget {
  const ResoursesScreenSorpresa({super.key});

  @override
  State<ResoursesScreenSorpresa> createState() =>
      _ResoursesScreenSorpresaState();
}

class _ResoursesScreenSorpresaState extends State<ResoursesScreenSorpresa>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool mostrarRuleta = false;
  SurpriseActivity? actividadSeleccionada;
  bool girando = false;
  late AnimationController _controller;

  final SurpriseActivityRepository _repository =
      SurpriseActivityRepositoryImpl();
  List<SurpriseActivity> _actividades = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _inicializarActividades();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Se ejecuta cuando la app vuelve a primer plano
      _sincronizarActividades();
    }
  }

  Future<List<String>> _cargarActividadesDesdeJSON() async {
    final String response = await rootBundle.loadString('assets/actividades/actividades.json');
    final List<dynamic> data = json.decode(response);
    return data.map((item) => item.toString()).toList();
  }

  Future<void> _inicializarActividades() async {
    final guardadas = await _repository.getAll();

    if (guardadas.isEmpty) {
      final actividadesDesdeJSON = await _cargarActividadesDesdeJSON();
      for (final descripcion in actividadesDesdeJSON) {
        await _repository.insert(
          SurpriseActivity(description: descripcion, isFavorite: false),
        );
      }
    }

    _actividades = await _repository.getAll();
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sincronizarActividades() async {
    if (!mounted) return;
    // Limpiar elementos expirados
    await _repository.limpiarPapeleraExpirada();
    
    final nuevasActividades = await _repository.getAll();
    setState(() {
      _actividades = nuevasActividades;
      // Si hay una actividad seleccionada, actualizar su estado desde BD
      if (actividadSeleccionada != null) {
        try {
          final actualizada = nuevasActividades.firstWhere(
            (act) => act.id == actividadSeleccionada!.id,
          );
          actividadSeleccionada = actualizada;
        } catch (e) {
          // No encontrada, resetear
          actividadSeleccionada = null;
        }
      }
    });
  }

  void girarRuleta() {
    if (_actividades.isEmpty) return;

    setState(() {
      girando = true;
      actividadSeleccionada = null;
    });

    _controller.reset();
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      final random = _actividades[Random().nextInt(_actividades.length)];
      setState(() {
        actividadSeleccionada = random;
        girando = false;
      });
    });
  }

  Future<void> refreshActividades() async {
    await _sincronizarActividades();
  }

  void _abrirFavoritos() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurpriseActivityFavoritesScreen(
          onFavoritosUpdated: _sincronizarActividades,
        ),
      ),
    );
  }

  Future<void> _toggleFavorito() async {
    if (actividadSeleccionada?.id == null) return;

    final favoritoActual = actividadSeleccionada!.isFavorite;
    if (favoritoActual) {
      // Si ya era favorito, lo mandamos a papelera
      await _repository.moverAPapelera(actividadSeleccionada!.id!);
      // Actualizar estado local
      setState(() {
        actividadSeleccionada = actividadSeleccionada!.copyWith(isFavorite: false);
      });
    } else {
      await _repository.toggleFavorito(
        actividadSeleccionada!.id!,
        true,
      );
      // Actualizar estado local
      setState(() {
        actividadSeleccionada = actividadSeleccionada!.copyWith(isFavorite: true);
      });
    }

    // Recargar la lista completa para mantener consistencia
    _actividades = await _repository.getAll();

    // Actualizar actividadSeleccionada con el estado actual de la BD
    if (actividadSeleccionada != null) {
      final actividadActualizada = _actividades.firstWhere(
        (act) => act.id == actividadSeleccionada!.id,
        orElse: () => actividadSeleccionada!,
      );
      setState(() {
        actividadSeleccionada = actividadActualizada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF4FB),
      appBar: AppBar(
        title: const Text(
          'Actividad Sorpresa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF4A90D9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(2);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white, size: 26),
            tooltip: 'Ver favoritos',
            onPressed: _abrirFavoritos,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFEEF4FB),
              const Color(0xFFD9E9F7),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _actividades.isEmpty
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90D9)),
                  )
                : !mostrarRuleta
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4A90D9).withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF4FB),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Text(
                                    '✨',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  '¿Necesitas inspiración?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Deja que te sugiera una actividad que puede mejorar tu bienestar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF6B7280),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 1.0, end: 1.05),
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeInOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  mostrarRuleta = true;
                                });
                              },
                              icon: const Icon(Icons.casino, size: 24),
                              label: const Text(
                                'Sorpréndeme',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A90D9),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 56,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                elevation: 8,
                                shadowColor: const Color(0xFF4A90D9).withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.8, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4A90D9).withOpacity(0.3),
                                    blurRadius: 25,
                                    offset: const Offset(0, 12),
                                    spreadRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFF4A90D9).withOpacity(0.1),
                                    blurRadius: 45,
                                    offset: const Offset(0, 25),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: girando
                                    ? RotationTransition(
                                        turns: _controller,
                                        child: const Text(
                                          '🎁',
                                          style: TextStyle(fontSize: 90),
                                        ),
                                      )
                                    : actividadSeleccionada == null
                                        ? const Text(
                                            '🎁',
                                            style: TextStyle(fontSize: 90),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(24),
                                            child: SingleChildScrollView(
                                              child: Text(
                                                actividadSeleccionada!.description,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF2D3142),
                                                  height: 1.3,
                                                ),
                                              ),
                                            ),
                                          ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          if (actividadSeleccionada != null)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  actividadSeleccionada!.isFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 36,
                                ),
                                onPressed: _toggleFavorito,
                                tooltip: 'Marcar como favorita',
                              ),
                            ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: girando ? null : girarRuleta,
                            icon: const Icon(Icons.refresh, size: 22),
                            label: Text(
                              actividadSeleccionada == null
                                  ? 'Girar'
                                  : 'Otra actividad',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF627EEA),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 52,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 6,
                              shadowColor: const Color(0xFF627EEA).withOpacity(0.4),
                              disabledBackgroundColor: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}

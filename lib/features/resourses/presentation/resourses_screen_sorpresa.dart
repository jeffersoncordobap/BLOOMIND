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
  String? actividadSeleccionada;
  bool girando = false;
  late AnimationController _controller;

  final List<String> actividades = [
    'Medita por 5 minutos',
    'Toma un vaso de agua',
    'Respira profundamente por 1 minuto',
    'Estírate por 2 minutos',
    'Camina por 5 minutos',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void girarRuleta() {
    setState(() {
      girando = true;
      actividadSeleccionada = null;
    });

    _controller.reset();
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        actividadSeleccionada = actividades[Random().nextInt(actividades.length)];
        girando = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        title: const Text('Actividad sorpresa'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
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
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '¿Necesitas inspiración para tu día?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Deja que te sugiera una actividad que puede mejorar tu bienestar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
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
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Sorpréndeme',
                        style: TextStyle(fontSize: 18, color: colorScheme.onPrimary),
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
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Center(
                        child: girando
                            ? RotationTransition(
                                turns: _controller,
                                child: Text(
                                  '🎁',
                                  style: TextStyle(
                                    fontSize: 80,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              )
                            : actividadSeleccionada == null
                                ? Text(
                                    '🎁',
                                    style: TextStyle(
                                      fontSize: 80,
                                      color: colorScheme.primary,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      actividadSeleccionada!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: girando ? null : girarRuleta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
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
                        style: TextStyle(fontSize: 18, color: colorScheme.onSecondary),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
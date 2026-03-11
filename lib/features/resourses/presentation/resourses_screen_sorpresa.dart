import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ResoursesScreenSorpresa extends StatefulWidget {
  const ResoursesScreenSorpresa({super.key});

  @override
  State<ResoursesScreenSorpresa> createState() => _ResoursesScreenSorpresaState();
}

class _ResoursesScreenSorpresaState extends State<ResoursesScreenSorpresa> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text('Actividad sorpresa'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
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
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Deja que te sugiera una actividad que puede mejorar tu bienestar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
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
                        backgroundColor: Colors.green,
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
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
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
                                      actividadSeleccionada!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: girando ? null : girarRuleta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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

//import 'package:bloomind/features/resourses/favorite_interfaz/meditation_favorite_interfaz.dart';
import 'package:bloomind/features/resourses/presentation/resourses_screen_audios.dart';
import 'package:bloomind/features/resourses/presentation/resourses_screen_frases.dart';
import 'package:bloomind/features/resourses/presentation/resourses_screen_meditacion.dart';
import 'package:bloomind/features/resourses/presentation/resourses_screen_sorpresa.dart';
import 'package:bloomind/features/routines/presentation/assign_routines_screen.dart';
import 'package:bloomind/features/routines/presentation/day_routine_screen.dart';
import 'package:bloomind/features/routines/presentation/routines_list_screen.dart';
import 'package:bloomind/features/routines/presentation/ruotine_screen.dart';
import 'package:flutter/material.dart';
import 'features/emotions/presentation/screens/emotion_record_screen.dart';
import 'features/emotions/presentation/screens/emotion_list_screen.dart';
import 'package:bloomind/features/estadisticas/presentation/statistics_screen.dart';
import 'features/resourses/presentation/resourses_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<widget_meditacionState> meditacionKey = GlobalKey<widget_meditacionState>();
  final GlobalKey<StatisticsScreenState> _statisticsKey =
  GlobalKey<StatisticsScreenState>();
  final GlobalKey<ResoursesScreenFrasesState> frasesKey = GlobalKey<ResoursesScreenFrasesState>();
  @override
  void initState() {
    super.initState();
    _screens = [
      RegistroEmocionalScreen(alPresionarDiario: irAlDiario),

      RoutineScreen(
        alPresionarListaRutinas: irAlistaRutinas,
        alPresionarAsignarRutinas: irAAsignarRutinas,
        alPresionarVerRutinaDia: irAverRutinaDelDia,
      ),

      RecurseScreen(
        alPresionarMeditacionRespiracion: irAverRecursosMeditaciones,
        alPresionarResoursesScreenFrases: irAVerResoursesScreenFrases,
        alPresionarResoursesScreenAudios: irAVerResoursesScreenAudios,
        alPresionarResoursesScreenSorpresa: irAVerResoursesScreenSorpresa,
      ),

      StatisticsScreen(key: _statisticsKey),
      const SettingsScreen(),
      const EmotionListScreen(),
      const RoutineListScreen(),
      const AssignRoutineScreen(),
      const DayRoutineScreen(),
      widget_meditacion(key: meditacionKey), // 9
      ResoursesScreenFrases(key: frasesKey), // 10
      const widget_audios(), // 11
      const ResoursesScreenSorpresa(), // 12
    ];
  }

  void cambiarIndice(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      _statisticsKey.currentState?.refreshStatistics();
    }
    if (index == 10) {
      frasesKey.currentState?.refreshFrases();
    }
    if (index == 9) {
      meditacionKey.currentState?.meditationRefresh(); 
    }
    
  }

  void irAlDiario() {
    setState(() {
      _selectedIndex = 5;
    });
  }

  void irAlistaRutinas() {
    setState(() {
      _selectedIndex = 6;
    });
  }

  void irAAsignarRutinas() {
    setState(() {
      _selectedIndex = 7;
    });
  }

  void irAverRutinaDelDia() {
    setState(() {
      _selectedIndex = 8;
    });
  }

  void irAverRecursosMeditaciones() {
    cambiarIndice(9);
  }

  void irAVerResoursesScreenFrases() {
    cambiarIndice(10);
  }

  void irAVerResoursesScreenAudios() {
    setState(() {
      _selectedIndex = 11;
    });
  }

  void irAVerResoursesScreenSorpresa() {
    setState(() {
      _selectedIndex = 12;
    });
  }

  Widget _buildIcon(IconData iconData, Color color, int index) {
    bool isSelected = _selectedIndex == index;

    if (_selectedIndex == 5 && index == 0) isSelected = true;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black.withOpacity(0.08) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: isSelected ? 30 : 26),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
          onTap: cambiarIndice,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.local_florist, Colors.pinkAccent, 0),
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.self_improvement, Colors.orange, 1),
              label: "Rutinas",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.extension, Colors.green, 2),
              label: "Recursos",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.bar_chart, Colors.blue, 3),
              label: "Stats",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.settings, Colors.grey, 4),
              label: "Ajustes",
            ),
          ],
        ),
      ),
    );
  }
}
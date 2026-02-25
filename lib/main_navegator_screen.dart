import 'package:bloomind/features/routines/presentation/ruotine_screen.dart';
import 'package:flutter/material.dart';
import 'features/emotions/presentation/screens/emotion_record_screen.dart';
import 'features/emotions/presentation/screens/emotion_list_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RegistroEmocionalScreen(),
    const RoutineScreen(),
    const Center(child: Text("Recursos")),
    const Center(child: Text("Estadísticas")),
    const Center(child: Text("Configuración")),
    const EmotionListScreen(),
  ];

  void cambiarIndice(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void irAlDiario() {
    setState(() {
      _selectedIndex = 5;
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

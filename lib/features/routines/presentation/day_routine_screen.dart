import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/day_routine_controller.dart';

class DayRoutineScreen extends StatefulWidget {
  const DayRoutineScreen({super.key});

  @override
  State<DayRoutineScreen> createState() => _DayRoutineScreenState();
}

class _DayRoutineScreenState extends State<DayRoutineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DayRoutineController>().loadTodayRoutine();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DayRoutineController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          "Rutina del día",
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(1);
          },
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(controller),
    );
  }

  Widget _buildContent(DayRoutineController controller) {
    if (controller.dayActivities.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: controller.dayActivities.length,
            itemBuilder: (context, index) {
              final activity = controller.dayActivities[index];
              return _buildActivityCard(activity);
            },
          ),
        ),
        _buildAddActivityButton(),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildActivityCard(dynamic activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(activity.emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${activity.hour} · ${activity.category}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddActivityButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () {
            debugPrint("Navegar a agregar actividad");
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Agregar actividad",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6495ED),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "😊 Hoy no tienes una rutina asignada",
            style: TextStyle(color: Color(0xFF7D8FA9), fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildAddActivityButton(),
        ],
      ),
    );
  }
}

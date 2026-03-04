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
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          "Rutina de Hoy",
          style: TextStyle(color: Color(0xFF2D3142)),
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
          : controller.dayActivities.isEmpty
          ? _buildEmptyState()
          : _buildActivitiesList(controller),
    );
  }

  Widget _buildActivitiesList(DayRoutineController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.dayActivities.length,
      itemBuilder: (context, index) {
        final activity = controller.dayActivities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Text(activity.emoji, style: const TextStyle(fontSize: 25)),
            title: Text(
              activity.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${activity.hour} - ${activity.category}"),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "No hay rutina asignada para hoy.",
        style: TextStyle(color: Color(0xFF7D8FA9), fontSize: 16),
      ),
    );
  }
}

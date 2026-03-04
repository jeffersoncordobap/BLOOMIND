import 'package:bloomind/features/routines/controller/routine_controller.dart';
import 'package:bloomind/features/routines/presentation/rutine_detail_screen.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineListScreen extends StatefulWidget {
  const RoutineListScreen({super.key});

  @override
  State<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends State<RoutineListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoutineController>().fetchRoutines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RoutineController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Mis rutinas",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(1);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.routines.isEmpty
                ? const Center(child: Text("No tienes rutinas aún."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.routines.length,
                    itemBuilder: (context, index) {
                      return _buildRoutineCard(
                        controller.routines[index],
                        controller,
                      );
                    },
                  ),
          ),
          _buildAddButton(context, controller),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(dynamic routine, RoutineController controller) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoutineDetailScreen(routine: routine),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                routine.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                controller.removeRoutine(routine.idRoutine!, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, RoutineController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: () => _showAddDialog(context, controller),
          icon: const Icon(Icons.add),
          label: const Text("Agregar rutina"),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, RoutineController controller) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nueva Rutina"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Nombre de la rutina"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                controller.addRoutine(textController.text, context);
                Navigator.pop(context);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}

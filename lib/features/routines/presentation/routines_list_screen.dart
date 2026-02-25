import 'package:bloomind/features/routines/controller/routine_controller.dart';
import 'package:bloomind/features/routines/repository/routine_repository_impl.dart';
import 'package:flutter/material.dart';

class RoutineListScreen extends StatefulWidget {
  const RoutineListScreen({super.key});

  @override
  State<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends State<RoutineListScreen> {
  final RoutineController controller = RoutineController(
    repository: RoutineRepositoryImpl(),
  );

  @override
  void initState() {
    super.initState();
    controller.fetchRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Mis rutinas",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.routines.isEmpty) {
                  return const Center(child: Text("No tienes rutinas aún."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.routines.length,
                  itemBuilder: (context, index) {
                    final routine = controller.routines[index];
                    return _buildRoutineCard(routine);
                  },
                );
              },
            ),
          ),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(dynamic routine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                routine.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Actividades", style: TextStyle(color: Colors.grey)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => controller.removeRoutine(routine.idRoutine!),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: () => _showAddDialog(context),
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

  void _showAddDialog(BuildContext context) {
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
                controller.addRoutine(textController.text);
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

import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
import 'package:bloomind/features/routines/controller/routine_controller.dart';
import 'package:bloomind/features/routines/model/routine.dart';
import 'package:bloomind/features/routines/presentation/provider/routine_provider.dart';
import 'package:bloomind/features/settings/controller/bin_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BinRoutinesScreen extends StatefulWidget {
  const BinRoutinesScreen({super.key});

  @override
  State<BinRoutinesScreen> createState() => _BinRoutinesScreenState();
}

class _BinRoutinesScreenState extends State<BinRoutinesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BinController>().loadDeletedRoutines();
    });
  }

  void _showOptionsDialog(Routine routine) {
    final binController = context.read<BinController>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.restore_from_trash,
                color: Color.fromARGB(221, 48, 199, 230),
              ),
              title: const Text("Restaurar"),
              onTap: () async {
                Navigator.pop(dialogContext);

                await binController.restoreRoutine(routine.idRoutine!);

                if (mounted) {
                  // Intentamos actualizar la lista principal de rutinas si el controlador está disponible
                  try {
                    context.read<RoutineController>().fetchRoutines();
                  } catch (e) {
                    // El controlador podría no estar en el árbol si venimos de otro lado
                    debugPrint(
                      "RoutineController no encontrado o no necesario actualizar: $e",
                    );
                  }

                  // Actualizar RoutineProvider (Tarjeta de Próxima Actividad)
                  try {
                    context.read<RoutineProvider>().updateUpcomingActivity();
                  } catch (e) {
                    debugPrint("RoutineProvider no encontrado: $e");
                  }

                  // Actualizar Rutina del Día (por si la rutina restaurada es la de hoy)
                  try {
                    context.read<DayRoutineController>().loadTodayRoutine();
                  } catch (e) {
                    debugPrint("DayRoutineController no encontrado: $e");
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rutina restaurada correctamente'),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever,
                color: Color.fromARGB(221, 232, 68, 68),
              ),
              title: const Text("Eliminar definitivamente"),
              onTap: () {
                Navigator.pop(dialogContext);
                binController.forceDeleteRoutine(routine.idRoutine!);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BinController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text(
          "Papelera de rutinas",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Aquí puedes ver las rutinas que has eliminado.",
              style: TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.deletedRoutines.isEmpty
                ? const Center(child: Text("No tienes rutinas eliminadas"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.deletedRoutines.length,
                    itemBuilder: (context, index) {
                      final routine = controller.deletedRoutines[index];
                      return GestureDetector(
                        onLongPress: () => _showOptionsDialog(routine),
                        child: _DeleteRoutineCard(routine: routine),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DeleteRoutineCard extends StatelessWidget {
  final Routine routine;
  const _DeleteRoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text("🏋️‍♂️", style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              routine.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.restore_from_trash_rounded,
              color: Colors.green[600],
            ),
            tooltip: "Restaurar",
            onPressed: () async {
              await context.read<BinController>().restoreRoutine(
                routine.idRoutine!,
              );
              if (context.mounted) {
                // Actualizar inmediatamente la lista de rutinas disponibles
                try {
                  context.read<RoutineController>().fetchRoutines();
                } catch (e) {
                  debugPrint(
                    "RoutineController no encontrado para actualizar: $e",
                  );
                }

                // Actualizar RoutineProvider (Tarjeta de Próxima Actividad)
                try {
                  context.read<RoutineProvider>().updateUpcomingActivity();
                } catch (e) {
                  debugPrint("RoutineProvider no encontrado: $e");
                }

                // Actualizar Rutina del Día
                try {
                  context.read<DayRoutineController>().loadTodayRoutine();
                } catch (e) {
                  debugPrint("DayRoutineController no encontrado: $e");
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rutina restaurada')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

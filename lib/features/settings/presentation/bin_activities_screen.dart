import 'package:bloomind/features/activities/model/activity.dart';
import 'package:bloomind/features/activities/controller/activity_controller.dart';
import 'package:bloomind/features/settings/controller/bin_controller.dart';
import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnlyActivitiesRemovedScreen extends StatefulWidget {
  const OnlyActivitiesRemovedScreen({super.key});

  @override
  State<OnlyActivitiesRemovedScreen> createState() =>
      _OnlyActivityRemovedScreenState();
}

class _OnlyActivityRemovedScreenState
    extends State<OnlyActivitiesRemovedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BinController>().loadDeletedActivities();
    });
  }

  void _showOptionsDialog(Activity activity) {
    // 1. Capturamos el controlador AQUÍ, usando el contexto de la pantalla que sí tiene el Provider
    final binController = context.read<BinController>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // 2. Renombramos a dialogContext para no confundir
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

                // 1. Restaurar en BD y actualizar lista de Papelera
                await binController.restoreActivity(
                  // 3. Usamos la variable capturada
                  activity.idActivity!,
                );

                // 2. Actualizar el controlador principal (Calendario/Lista activa)
                if (mounted) {
                  // Actualizamos las categorías para que la actividad vuelva a aparecer disponible
                  context.read<ActivityController>().loadCategories();

                  // Actualizamos la rutina del día para que la actividad reaparezca inmediatamente en la lista
                  context.read<DayRoutineController>().loadTodayRoutine();

                  // 3. Feedback visual
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Actividad restaurada correctamente'),
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
                binController.forceDeleteActivity(
                  // 3. Usamos la variable capturada
                  activity.idActivity!,
                );
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
          "Papelera de actividades",
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
              "Aquí puedes ver las actividades que has eliminado. Restáuralas si fue un error.",
              style: TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.deletedActivities.isEmpty
                ? const Center(child: Text("No tienes actividades eliminadas"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.deletedActivities.length,
                    itemBuilder: (context, index) {
                      final activity = controller.deletedActivities[index];
                      return GestureDetector(
                        onLongPress: () => _showOptionsDialog(activity),
                        child: _DeleteActivityCard(activity: activity),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DeleteActivityCard extends StatelessWidget {
  final Activity activity;
  const _DeleteActivityCard({super.key, required this.activity});

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
          // 1. Emoji representativo
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(activity.emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          // 2. Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.category,
                  style: const TextStyle(
                    color: Color(0xFF6A94C9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // 3. Botón rápido de Restaurar
          IconButton(
            icon: Icon(
              Icons.restore_from_trash_rounded,
              color: Colors.green[600],
            ),
            tooltip: "Restaurar",
            onPressed: () async {
              await context.read<BinController>().restoreActivity(
                activity.idActivity!,
              );

              if (context.mounted) {
                // Actualizamos la lista principal para ver el cambio al volver
                context.read<ActivityController>().loadCategories();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Actividad restaurada')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

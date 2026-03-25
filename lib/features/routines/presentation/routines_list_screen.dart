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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Mis rutinas",
          style: TextStyle(color: colorScheme.onBackground),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
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
                    ? Center(
                        child: Text(
                          "No tienes rutinas aún.",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      )
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
          _buildAddButton(context, controller, colorScheme),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(
      dynamic routine, RoutineController controller) {
    final colorScheme = Theme.of(context).colorScheme;

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
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                routine.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: colorScheme.error),
              onPressed: () {
                controller.removeRoutine(routine.idRoutine!, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(
      BuildContext context, RoutineController controller, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: () => _showAddDialog(context, controller, colorScheme),
          icon: Icon(Icons.add, color: colorScheme.primary),
          label: Text(
            "Agregar rutina",
            style: TextStyle(color: colorScheme.primary),
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: colorScheme.primary),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(
      BuildContext context, RoutineController controller, ColorScheme colorScheme) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(
          "Nueva Rutina",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: TextField(
          controller: textController,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: "Nombre de la rutina",
            hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
            filled: true,
            fillColor: colorScheme.surfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                controller.addRoutine(textController.text, context);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
            ),
            child: Text(
              "Guardar",
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
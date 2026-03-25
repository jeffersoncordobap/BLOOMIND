import 'package:bloomind/features/resourses/controller/support_line_controller.dart';
import 'package:bloomind/features/resourses/model/support_line.dart';
import 'package:bloomind/features/settings/controller/bin_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BinSupportLinesScreen extends StatefulWidget {
  const BinSupportLinesScreen({super.key});

  @override
  State<BinSupportLinesScreen> createState() => _BinSupportLinesScreenState();
}

class _BinSupportLinesScreenState extends State<BinSupportLinesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BinController>().loadDeletedSupportLines();
    });
  }

  void _showOptionsDialog(SupportLine line) {
    final binController = context.read<BinController>();
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.restore_from_trash, color: colorScheme.primary),
              title: Text("Restaurar", style: TextStyle(color: colorScheme.onSurface)),
              onTap: () async {
                Navigator.pop(dialogContext);
                await binController.restoreSupportLine(line.idContact!);

                if (mounted) {
                  try {
                    final supportController = context.read<SupportLineController>();
                    supportController.loadSupportLines();
                    supportController.loadFavorites();
                  } catch (e) {
                    debugPrint("SupportLineController no encontrado: $e");
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Contacto restaurado correctamente', style: TextStyle(color: colorScheme.onSurface)),
                      backgroundColor: colorScheme.surface,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: colorScheme.error),
              title: Text("Eliminar definitivamente", style: TextStyle(color: colorScheme.error)),
              onTap: () {
                Navigator.pop(dialogContext);
                binController.forceDeleteSupportLine(line.idContact!);
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        title: Text(
          "Papelera de contactos",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Aquí puedes ver los contactos que has eliminado.",
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
                : controller.deletedSupportLines.isEmpty
                    ? Center(
                        child: Text(
                          "No tienes contactos eliminados",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.deletedSupportLines.length,
                        itemBuilder: (context, index) {
                          final line = controller.deletedSupportLines[index];
                          return GestureDetector(
                            onLongPress: () => _showOptionsDialog(line),
                            child: _DeleteSupportLineCard(line: line),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _DeleteSupportLineCard extends StatelessWidget {
  final SupportLine line;
  const _DeleteSupportLineCard({required this.line});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.person, color: colorScheme.onSurface.withValues(alpha: 0.4), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  line.phone,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.restore_from_trash_rounded,
              color: colorScheme.secondary,
            ),
            tooltip: "Restaurar",
            onPressed: () async {
              await context.read<BinController>().restoreSupportLine(line.idContact!);

              if (context.mounted) {
                try {
                  final supportController = context.read<SupportLineController>();
                  supportController.loadSupportLines();
                  supportController.loadFavorites();
                } catch (e) {
                  debugPrint("SupportLineController no encontrado: $e");
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Contacto restaurado', style: TextStyle(color: colorScheme.onSurface)),
                    backgroundColor: colorScheme.surface,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
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

                await binController.restoreSupportLine(line.idContact!);

                if (mounted) {
                  // Actualizar las listas del controlador principal
                  try {
                    final supportController = context
                        .read<SupportLineController>();
                    supportController.loadSupportLines();
                    supportController.loadFavorites();
                  } catch (e) {
                    debugPrint("SupportLineController no encontrado: $e");
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contacto restaurado correctamente'),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text(
          "Papelera de contactos",
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
              "Aquí puedes ver los contactos que has eliminado.",
              style: TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.deletedSupportLines.isEmpty
                ? const Center(child: Text("No tienes contactos eliminados"))
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
            child: const Icon(Icons.person, color: Colors.grey, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  line.phone,
                  style: const TextStyle(
                    color: Color(0xFF6A94C9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.restore_from_trash_rounded,
              color: Colors.green[600],
            ),
            tooltip: "Restaurar",
            onPressed: () async {
              await context.read<BinController>().restoreSupportLine(
                line.idContact!,
              );

              if (context.mounted) {
                try {
                  final supportController = context
                      .read<SupportLineController>();
                  supportController.loadSupportLines();
                  supportController.loadFavorites();
                } catch (e) {
                  debugPrint("SupportLineController no encontrado: $e");
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contacto restaurado')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

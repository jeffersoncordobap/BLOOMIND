import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloomind/features/resourses/model/support_line.dart';
import '../controller/support_line_controller.dart';

class SupportLinesScreen extends StatefulWidget {
  const SupportLinesScreen({super.key});

  @override
  State<SupportLinesScreen> createState() => _SupportLinesScreenState();
}

class _SupportLinesScreenState extends State<SupportLinesScreen> {
  // 1. Controladores para los campos del diálogo
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupportLineController>().loadSupportLines();
    });
  }

  // 2. Limpieza de controladores al destruir el widget
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // 3. Método para mostrar el diálogo de agregar
  void _showAddLineDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text(
            "Nueva línea de apoyo",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(_nameController, "Ej: Mamá"),
              const SizedBox(height: 15),
              _buildDialogTextField(
                _phoneController,
                "Ej: +57 3000000000",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              _buildDialogTextField(
                _descController,
                "Ej: Disponible para hablar",
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.isNotEmpty &&
                          _phoneController.text.isNotEmpty) {
                        final newLine = SupportLine(
                          name: _nameController.text,
                          phone: _phoneController.text,
                          description: _descController.text,
                          isFavorite: false,
                        );

                        final success = await context
                            .read<SupportLineController>()
                            .addSupportLine(newLine);

                        if (success) {
                          _nameController.clear();
                          _phoneController.clear();
                          _descController.clear();
                          if (mounted) Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A94C9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Agregar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 4. Widget auxiliar para los inputs del diálogo
  Widget _buildDialogTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF2F4F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SupportLineController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Mis líneas de apoyo"),
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
              "Mantén presionado algún contacto si quieres más opciones.",
              style: TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.lines.isEmpty
                ? const Center(child: Text("No tienes contactos guardados"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.lines.length,
                    itemBuilder: (context, index) {
                      final line = controller.lines[index];
                      return _SupportLineCard(line: line);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _showAddLineDialog(); // Llamada al diálogo unida con éxito
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Agregar línea de apoyo",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A94C9),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportLineCard extends StatelessWidget {
  final SupportLine line;

  const _SupportLineCard({required this.line});

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
                    fontSize: 15,
                  ),
                ),
                if (line.description != null &&
                    line.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '"${line.description}"',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              line.isFavorite ? Icons.star : Icons.star_border,
              color: line.isFavorite ? Colors.amber : Colors.black26,
            ),
            onPressed: () {
              context.read<SupportLineController>().toggleFavorite(line);
            },
          ),
        ],
      ),
    );
  }
}

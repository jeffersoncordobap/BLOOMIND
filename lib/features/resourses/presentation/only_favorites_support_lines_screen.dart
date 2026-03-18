import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Asegúrate de tenerlo en pubspec.yaml
import 'package:bloomind/features/resourses/model/support_line.dart';
import '../controller/support_line_controller.dart';

class OnlyFavoritesSupportLinesScreen extends StatefulWidget {
  const OnlyFavoritesSupportLinesScreen({super.key});

  @override
  State<OnlyFavoritesSupportLinesScreen> createState() =>
      _OnlyFavoritesSupportLinesScreenState();
}

class _OnlyFavoritesSupportLinesScreenState
    extends State<OnlyFavoritesSupportLinesScreen> {
  // 1. Controladores para los campos del diálogo
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargamos solo los favoritos
      context.read<SupportLineController>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE COMUNICACIÓN ---

  Future<void> _makeCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanPhone.length == 10) {
      cleanPhone = '57$cleanPhone';
    }

    final Uri url = Uri.parse('https://wa.me/$cleanPhone');

    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint("No se pudo abrir WhatsApp");
      }
    } catch (e) {
      debugPrint("Error al abrir WhatsApp: $e");
    }
  }

  // Diálogo de Opciones (Llamar, WA, Editar, Eliminar)
  void _showOptionsDialog(SupportLine line) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.call, color: Colors.black87),
              title: const Text("Llamar"),
              onTap: () {
                Navigator.pop(context);
                _makeCall(line.phone);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.black87,
              ),
              title: const Text("WhatsApp"),
              onTap: () {
                Navigator.pop(context);
                _openWhatsApp(line.phone);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Colors.black87),
              title: const Text("Editar"),
              onTap: () {
                Navigator.pop(context);
                _showAddOrEditDialog(line: line);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
              title: const Text(
                "Eliminar",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                Navigator.pop(context);
                await context.read<SupportLineController>().deleteSupportLine(
                  line.idContact!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo Unificado para Agregar o Editar
  void _showAddOrEditDialog({SupportLine? line}) {
    final isEditing = line != null;

    if (isEditing) {
      _nameController.text = line.name;
      _phoneController.text = line.phone;
      _descController.text = line.description ?? "";
    } else {
      _nameController.clear();
      _phoneController.clear();
      _descController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(
          isEditing ? "Editar línea de apoyo" : "Nueva línea de apoyo",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty) {
                      final updatedLine = SupportLine(
                        idContact: line?.idContact,
                        name: _nameController.text,
                        phone: _phoneController.text,
                        description: _descController.text,
                        isFavorite: line?.isFavorite ?? false,
                      );

                      bool success;
                      if (isEditing) {
                        success = await context
                            .read<SupportLineController>()
                            .updateSupportLine(updatedLine);
                      } else {
                        success = await context
                            .read<SupportLineController>()
                            .addSupportLine(updatedLine);
                      }

                      if (success && mounted) Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A94C9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    isEditing ? "Guardar" : "Agregar",
                    style: const TextStyle(color: Colors.white),
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
      ),
    );
  }

  // Input auxiliar
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
                : controller.favoriteLines.isEmpty
                ? const Center(child: Text("No tienes favoritos guardados"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.favoriteLines.length,
                    itemBuilder: (context, index) {
                      final line = controller.favoriteLines[index];
                      return GestureDetector(
                        onLongPress: () => _showOptionsDialog(line),
                        child: _SupportLineCard(line: line),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAddOrEditDialog(),
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

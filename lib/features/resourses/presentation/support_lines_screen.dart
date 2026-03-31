import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bloomind/features/resourses/model/support_line.dart';
import '../controller/support_line_controller.dart';

class SupportLinesScreen extends StatefulWidget {
  const SupportLinesScreen({super.key});

  @override
  State<SupportLinesScreen> createState() => _SupportLinesScreenState();
}

class _SupportLinesScreenState extends State<SupportLinesScreen> {
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    super.dispose();
  }

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
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _showOptionsDialog(SupportLine line) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.call, color: colorScheme.onSurface),
              title: Text("Llamar", style: TextStyle(color: colorScheme.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _makeCall(line.phone);
              },
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline, color: colorScheme.onSurface),
              title: Text("WhatsApp", style: TextStyle(color: colorScheme.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _openWhatsApp(line.phone);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
              title: Text("Editar", style: TextStyle(color: colorScheme.onSurface)),
              onTap: () {
                Navigator.pop(context);
                _showAddOrEditDialog(line: line);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
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

  void _showAddOrEditDialog({SupportLine? line}) {
    final colorScheme = Theme.of(context).colorScheme;
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
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
            _buildDialogTextField(_descController, "Ej: Disponible para hablar"),
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

                      if (isEditing) {
                        await context
                            .read<SupportLineController>()
                            .updateSupportLine(updatedLine);
                      } else {
                        await context
                            .read<SupportLineController>()
                            .addSupportLine(updatedLine);
                      }

                      if (mounted) Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    isEditing ? "Guardar" : "Agregar",
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: colorScheme.surfaceVariant,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("Mis líneas de apoyo"),
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
              "Mantén presionado algún contacto si quieres más opciones.",
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.lines.isEmpty
                    ? Center(
                        child: Text(
                          "No tienes contactos guardados",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.lines.length,
                        itemBuilder: (context, index) {
                          final line = controller.lines[index];
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
              icon: Icon(Icons.add, color: colorScheme.onPrimary),
              label: Text(
                "Agregar línea de apoyo",
                style: TextStyle(color: colorScheme.onPrimary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
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
                    fontSize: 15,
                  ),
                ),
                if (line.description != null &&
                    line.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '"${line.description}"',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
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
              color: line.isFavorite
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.4),
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
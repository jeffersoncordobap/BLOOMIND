import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bloomind/features/activities/controller/activity_controller.dart';
import 'package:bloomind/features/activities/model/activity.dart';

class ActivityScreen extends StatefulWidget {
  final int idRoutine;
  const ActivityScreen({super.key, required this.idRoutine});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();

  String? selectedCategory;
  bool _isFormVisible = false;
  List<Activity> lista_sugerencias = [];

  // Definición de colores basada en tus imágenes
  final Color backgroundColor = const Color(
    0xFFF1F5F9,
  ); // Gris muy claro de fondo
  final Color primaryBlue = const Color(0xFF75B1EA); // Azul del botón
  final Color labelColor = const Color(0xFF64748B); // Color de los títulos

  @override
  void initState() {
    super.initState();
    _emojiController.text = "✨";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityController>().categoriasIniciales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ActivityController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Agregar actividad",
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CATEGORÍA ---
            _buildLabel("Categoria"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: _containerDecoration(),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  hint: const Text("Estudio"),
                  items: controller.categoryItems.map((item) {
                    return DropdownMenuItem(
                      value: item.value,
                      child: Text(item.value!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                    if (value != null) _cargarSugerencias(value);
                  },
                ),
              ),
            ),

            Row(
              children: [
                _buildSmallButton(
                  "Nueva categoria",
                  () => setState(() => _isFormVisible = !_isFormVisible),
                ),
                const SizedBox(width: 10),
                if (selectedCategory != null)
                  _buildSmallButton("Eliminar categoria", _showDeleteDialog),
              ],
            ),

            if (_isFormVisible) _buildCategoryForm(controller),

            const SizedBox(height: 24),

            // --- SUGERENCIAS ---
            _buildLabel("Sugerencias"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: lista_sugerencias
                  .map(
                    (activity) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _activityNameController.text = activity.name;
                          _emojiController.text = activity.emoji;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFE0F2FE,
                          ), // Azul muy suave como en tu imagen
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: primaryBlue.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(activity.emoji),
                            const SizedBox(width: 8),
                            Text(
                              activity.name,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 24),

            // --- NOMBRE ACTIVIDAD ---
            _buildLabel("Nombre de actividad"),
            const SizedBox(height: 8),
            TextField(
              controller: _activityNameController,
              decoration: _inputDecoration("Ej: Escalar, pintar, escribir"),
            ),

            const SizedBox(height: 24),

            // --- EMOJI ---
            _buildLabel("Emoji"),
            const SizedBox(height: 8),
            TextField(
              controller: _emojiController,
              decoration: _inputDecoration(""),
              style: const TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 24),

            // --- HORA ---
            _buildLabel("Hora"),
            const SizedBox(height: 8),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: _inputDecoration("07:00 a. m.").copyWith(
                suffixIcon: const Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
              ),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null)
                  setState(() => _timeController.text = picked.format(context));
              },
            ),

            const SizedBox(height: 40),

            // --- BOTÓN GUARDAR ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: _guardarTodo,
                child: const Text(
                  "Guardar actividad",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: labelColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    );
  }

  Widget _buildSmallButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFE2E8F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF475569), fontSize: 14),
      ),
    );
  }

  // --- LÓGICA REUTILIZADA ---
  Future<void> _guardarTodo() async {
    final controller = context.read<ActivityController>();
    if (_activityNameController.text.isEmpty ||
        selectedCategory == null ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }
    bool success = await controller.saveActivityToRoutine(
      idRoutine: widget.idRoutine,
      name: _activityNameController.text,
      category: selectedCategory!,
      emoji: _emojiController.text.trim(),
      hour: _timeController.text,
    );
    if (success && mounted) Navigator.pop(context);
  }

  Future<void> _cargarSugerencias(String categoria) async {
    final nuevas = await context
        .read<ActivityController>()
        .obtener_recomendaciones(categoria);
    setState(() => lista_sugerencias = nuevas);
  }

  Widget _buildCategoryForm(ActivityController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                hintText: "Nueva categoría",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              String nueva = _categoryController.text.trim();
              if (nueva.isNotEmpty) {
                await controller.addCategory(nueva);
                setState(() {
                  selectedCategory = nueva;
                  _isFormVisible = false;
                  _categoryController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar categoría"),
        content: Text("¿Estás seguro de eliminar '$selectedCategory'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ActivityController>().removeCategory(
                selectedCategory!,
              );
              setState(() => selectedCategory = null);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

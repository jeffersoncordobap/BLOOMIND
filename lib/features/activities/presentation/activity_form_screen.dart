import 'package:bloomind/features/routines/controller/day_routine_controller.dart';
import 'package:bloomind/features/routines/presentation/provider/routine_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloomind/features/activities/controller/activity_controller.dart';
import 'package:bloomind/features/activities/model/activity.dart';

class ActivityScreen extends StatefulWidget {
  final int idRoutine;
  final Activity? activityToEdit;

  const ActivityScreen({
    super.key,
    required this.idRoutine,
    this.activityToEdit,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late TextEditingController _activityNameController;
  late TextEditingController _timeController;
  late TextEditingController _categoryController;
  late TextEditingController _emojiController;

  String? selectedCategory;
  bool _isFormVisible = false;
  List<Activity> lista_sugerencias = [];

  @override
  void initState() {
    super.initState();

    _activityNameController = TextEditingController(
      text: widget.activityToEdit?.name ?? "",
    );
    _timeController = TextEditingController(
      text: widget.activityToEdit?.hour ?? "",
    );
    _categoryController = TextEditingController();
    _emojiController = TextEditingController(
      text: widget.activityToEdit?.emoji ?? "✨",
    );

    selectedCategory = widget.activityToEdit?.category;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityController>().categoriasIniciales();
      if (selectedCategory != null) {
        _cargarSugerencias(selectedCategory!);
      }
    });
  }

  @override
  void dispose() {
    _activityNameController.dispose();
    _timeController.dispose();
    _categoryController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ActivityController>();
    final colorScheme = Theme.of(context).colorScheme;

    final String title = widget.activityToEdit != null
        ? "Editar actividad"
        : "Agregar actividad";

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Categoria", colorScheme),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: _containerDecoration(colorScheme),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  hint: Text(
                    "Selecciona una categoría",
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                  items: controller.categoryItems.map((item) {
                    return DropdownMenuItem(
                      value: item.value,
                      child: Text(
                        item.value!,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
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
                  colorScheme,
                ),
                const SizedBox(width: 10),
                if (selectedCategory != null)
                  _buildSmallButton("Eliminar categoria", _showDeleteDialog, colorScheme),
              ],
            ),

            if (_isFormVisible) _buildCategoryForm(controller, colorScheme),

            const SizedBox(height: 24),

            _buildLabel("Sugerencias", colorScheme),
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
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(activity.emoji),
                            const SizedBox(width: 8),
                            Text(
                              activity.name,
                              style: TextStyle(
                                color: colorScheme.onSurface,
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

            _buildLabel("Nombre de actividad", colorScheme),
            const SizedBox(height: 8),
            TextField(
              controller: _activityNameController,
              decoration: _inputDecoration("Ej: Escalar, pintar, escribir", colorScheme),
            ),

                        const SizedBox(height: 24),

            _buildLabel("Emoji", colorScheme),
            const SizedBox(height: 8),
            TextField(
              controller: _emojiController,
              decoration: _inputDecoration("", colorScheme),
              style: TextStyle(
                fontSize: 24,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel("Hora", colorScheme),
            const SizedBox(height: 8),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: _inputDecoration("07:00 a. m.", colorScheme).copyWith(
                suffixIcon: Icon(
                  Icons.access_time,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: widget.activityToEdit != null
                      ? _parseTimeString(_timeController.text)
                      : TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() => _timeController.text = picked.format(context));
                }
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: _guardarTodo,
                child: Text(
                  widget.activityToEdit != null
                      ? "Guardar cambios"
                      : "Guardar actividad",
                  style: TextStyle(
                    color: colorScheme.onPrimary,
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

  TimeOfDay _parseTimeString(String time) {
    try {
      final format = MediaQuery.of(context).alwaysUse24HourFormat
          ? "HH:mm"
          : "h:mm a";
      if (time.isEmpty) return TimeOfDay.now();
      return TimeOfDay.fromDateTime(
        DateTime.parse(
          "2024-01-01 ${time.replaceAll('a. m.', 'AM').replaceAll('p. m.', 'PM')}",
        ),
      );
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  Future<void> _guardarTodo() async {
    final controller = context.read<ActivityController>();

    if (_activityNameController.text.isEmpty ||
        selectedCategory == null ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Completa todos los campos",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
      return;
    }

    bool success = false;

    if (widget.activityToEdit != null) {
      final String originalHour = widget.activityToEdit!.hour;
      final updatedActivity = Activity(
        idActivity: widget.activityToEdit!.idActivity,
        name: _activityNameController.text,
        category: selectedCategory!,
        emoji: _emojiController.text.trim(),
        hour: _timeController.text,
      );

      success = await controller.updateExistingActivity(
        context: context,
        activity: updatedActivity,
        idRoutine: widget.idRoutine,
        oldHour: originalHour,
      );
    } else {
      success = await controller.saveActivityToRoutine(
        context: context,
        idRoutine: widget.idRoutine,
        name: _activityNameController.text,
        category: selectedCategory!,
        emoji: _emojiController.text.trim(),
        hour: _timeController.text,
      );
    }

    if (success && mounted) {
      context.read<DayRoutineController>().loadTodayRoutine();
      context.read<RoutineProvider>().updateUpcomingActivity();
      Navigator.pop(context);
    }
  }

  Widget _buildLabel(String text, ColorScheme colorScheme) {
    return Text(
      text,
      style: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, ColorScheme colorScheme) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  BoxDecoration _containerDecoration(ColorScheme colorScheme) => BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      );

  Widget _buildSmallButton(String text, VoidCallback onPressed, ColorScheme colorScheme) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: colorScheme.surfaceVariant.withValues(alpha: 0.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(
        text,
        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 14),
      ),
    );
  }

  Future<void> _cargarSugerencias(String categoria) async {
    final nuevas = await context.read<ActivityController>().obtener_recomendaciones(categoria);
    setState(() => lista_sugerencias = nuevas);
  }

  Widget _buildCategoryForm(ActivityController controller, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                hintText: "Nueva categoría",
                border: InputBorder.none,
                hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check, color: colorScheme.primary),
            onPressed: () async {
              String nueva = _categoryController.text.trim();
              if (nueva.isNotEmpty) {
                await controller.addCategory(nueva);
                setState(() {
                  selectedCategory = nueva;
                  _isFormVisible = false;
                  _categoryController.clear();
                });
                _cargarSugerencias(nueva);
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
        title: Text("Eliminar categoría", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        content: Text(
          "¿Estás seguro de eliminar '$selectedCategory'?",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ActivityController>().removeCategory(selectedCategory!);
              setState(() => selectedCategory = null);
              if (mounted) Navigator.pop(context);
            },
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
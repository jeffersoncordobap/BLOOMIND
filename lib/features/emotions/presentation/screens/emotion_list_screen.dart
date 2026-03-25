import 'package:bloomind/features/emotions/model/emotion.dart';
import 'package:bloomind/main_navegator_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../controller/emotion_controller.dart';

class EmotionListScreen extends StatefulWidget {
  const EmotionListScreen({super.key});

  @override
  State<EmotionListScreen> createState() => _EmotionListScreenState();
}

class _EmotionListScreenState extends State<EmotionListScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmotionController>().cargarEmocionesPorFecha(_selectedDay!);
    });
  }

  void _mostrarDialogoEdicion(BuildContext context, Emotion emo) {
    final controller = context.read<EmotionController>();
    final TextEditingController _editNotaController = TextEditingController(
      text: emo.note,
    );
    final List<String> opciones = [
      'Feliz',
      'Neutral',
      'Triste',
      'Enojado',
      'Cansado',
      'Desmotivado',
    ];
    String nuevaEtiqueta = emo.label;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Editar registro de hoy",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: opciones.map((label) {
                  bool esSeleccionado =
                      nuevaEtiqueta.toLowerCase() == label.toLowerCase();
                  return GestureDetector(
                    onTap: () => setModalState(() => nuevaEtiqueta = label),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: esSeleccionado
                            ? colorScheme.primary.withValues(alpha: 0.2)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: esSeleccionado
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _getEmoji(label),
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Text(
                "Emoción: $nuevaEtiqueta",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _editNotaController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Edita tu nota...",
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    final updatedEmo = Emotion(
                      idEmotion: emo.idEmotion,
                      moodLevel: controller.obtenerNivelDeAnimo(nuevaEtiqueta),
                      label: nuevaEtiqueta,
                      note: _editNotaController.text,
                      dateTime: emo.dateTime,
                    );
                    controller.actualizarEmocion(updatedEmo);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Actualizar Registro",
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmoji(String label) {
    switch (label.toLowerCase()) {
      case 'feliz':
        return '😊';
      case 'neutral':
        return '😐';
      case 'triste':
        return '😢';
      case 'enojado':
        return '😡';
      case 'cansado':
        return '😴';
      case 'desmotivado':
        return '😞';
      default:
        return '😶';
    }
  }

  void _confirmarEliminacion(
      BuildContext context, EmotionController controller, int id, DateTime fecha) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Eliminar registro?', style: TextStyle(color: colorScheme.onSurface)),
        content: Text(
          'Esta acción no se puede deshacer y solo es permitida para registros de hoy.',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: colorScheme.onSurface)),
          ),
          TextButton(
            onPressed: () {
              controller.eliminarEmocion(id, fecha);
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EmotionController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        title: Text(
          'Mi diario',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(0);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onSurface.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TableCalendar(
              locale: 'es_ES',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2035, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: colorScheme.onSurface),
                weekendTextStyle: TextStyle(color: colorScheme.onSurface),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                controller.cargarEmocionesPorFecha(selectedDay);
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat("EEEE, d 'de' MMMM", 'es_ES').format(_selectedDay!),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.emotionsForSelectedDay.isEmpty
                    ? Center(
                        child: Text(
                          "No hay registros para este día",
                          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.emotionsForSelectedDay.length,
                        itemBuilder: (context, index) {
                          final emo = controller.emotionsForSelectedDay[index];
                          final bool sePuedeEditar = controller.esHoy(_selectedDay!);
                          final hora = emo.dateTime.contains('T')
                              ? emo.dateTime.split('T')[1].substring(0, 5)
                              : "00:00";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _getEmoji(emo.label),
                                          style: TextStyle(fontSize: 26),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          hora,
                                          style: TextStyle(
                                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (sePuedeEditar)
                                      PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                        onSelected: (value) {
                                          if (value == 'eliminar') {
                                            _confirmarEliminacion(
                                              context,
                                              controller,
                                              emo.idEmotion!,
                                              _selectedDay!,
                                            );
                                          } else if (value == 'editar') {
                                            _mostrarDialogoEdicion(context, emo);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'editar',
                                            child: ListTile(
                                              leading: Icon(Icons.edit, size: 20),
                                              title: Text('Editar'),
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'eliminar',
                                            child: ListTile(
                                              leading: Icon(Icons.delete, size: 20, color: colorScheme.error),
                                              title: Text(
                                                'Eliminar',
                                                style: TextStyle(color: colorScheme.error),
                                              ),
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                if (emo.note.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    emo.note,
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
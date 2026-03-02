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
    // Cargar emociones de hoy al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmotionController>().cargarEmocionesPorFecha(_selectedDay!);
    });
  }

  void _mostrarDialogoEdicion(BuildContext context, Emotion emo) {
    final controller = context.read<EmotionController>();
    final TextEditingController _editNotaController = TextEditingController(
      text: emo.note,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Para que el teclado no tape el modal
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(
            context,
          ).viewInsets.bottom, // Ajuste para el teclado
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Editar registro",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: Text(
                _getEmoji(emo.label),
                style: const TextStyle(fontSize: 30),
              ),
              title: Text("Estado: ${emo.label}"),
              subtitle: const Text(
                "La emoción se mantiene, puedes editar la nota abajo.",
              ),
            ),
            TextField(
              controller: _editNotaController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Escribe tu nota aquí...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D86C7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Creamos el objeto actualizado
                  final updatedEmo = Emotion(
                    idEmotion: emo.idEmotion, // Mantener el mismo ID
                    moodLevel: emo.moodLevel,
                    label: emo.label,
                    note: _editNotaController.text,
                    dateTime: emo.dateTime,
                  );

                  controller.actualizarEmocion(updatedEmo);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Guardar cambios",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
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

  // DIÁLOGO DE CONFIRMACIÓN PARA ELIMINAR
  void _confirmarEliminacion(
    BuildContext context,
    EmotionController controller,
    int id,
    DateTime fecha,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar registro?'),
        content: const Text(
          'Esta acción no se puede deshacer y solo es permitida para registros de hoy.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.eliminarEmocion(id, fecha);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EmotionController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Mi diario',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context
                .findAncestorStateOfType<MainNavigationScreenState>()
                ?.cambiarIndice(0);
          },
        ),
      ),
      body: Column(
        children: [
          // CARD DEL CALENDARIO
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
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
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF4D86C7),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFFBDD4EB),
                  shape: BoxShape.circle,
                ),
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

          // TÍTULO DE LA FECHA SELECCIONADA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat("EEEE, d 'de' MMMM", 'es_ES').format(_selectedDay!),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // LISTADO DE EMOCIONES
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.emotionsForSelectedDay.isEmpty
                ? const Center(child: Text("No hay registros para este día"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.emotionsForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final emo = controller.emotionsForSelectedDay[index];

                      // Lógica de validación: ¿Es hoy?
                      final bool sePuedeEditar = controller.esHoy(
                        _selectedDay!,
                      );

                      final hora = emo.dateTime.contains('T')
                          ? emo.dateTime.split('T')[1].substring(0, 5)
                          : "00:00";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
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
                                      style: const TextStyle(fontSize: 26),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      hora,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),

                                // BOTONES DE ACCIÓN (SOLO SI ES HOY)
                                if (sePuedeEditar)
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
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
                                      const PopupMenuItem(
                                        value: 'editar',
                                        child: ListTile(
                                          leading: Icon(Icons.edit, size: 20),
                                          title: Text('Editar'),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'eliminar',
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          title: Text(
                                            'Eliminar',
                                            style: TextStyle(color: Colors.red),
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
                                style: const TextStyle(
                                  color: Colors.black87,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _emojis = [
    '😊', '😎', '🌸', '🦋', '🌟', '🎯', '🧘', '🌈', '🦁', '🐬', '🌻', '🎨'
  ];
  static const _generos = [
    'Femenino', 'Masculino', 'Otro', 'Prefiero no decir',
  ];

  late TextEditingController _nombreCtrl;
  late String _emojiSeleccionado;
  late String _generoSeleccionado;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileController>().profile;
    _nombreCtrl = TextEditingController(text: profile.nombre);
    _emojiSeleccionado = profile.emoji;
    _generoSeleccionado = profile.genero;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    await context.read<ProfileController>().guardar(
      nombre: _nombreCtrl.text.trim(),
      emoji: _emojiSeleccionado,
      genero: _generoSeleccionado,
    );
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Perfil guardado'),
        backgroundColor: colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String get _saludoPrevia {
    final nombre = _nombreCtrl.text.trim();
    final base = nombre.isNotEmpty ? nombre : 'tú';
    switch (_generoSeleccionado) {
      case 'Femenino':
        return 'Bienvenida, $base';
      case 'Masculino':
        return 'Bienvenido, $base';
      default:
        return 'Bienvenido/a, $base';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        title: Text(
          'Perfil local',
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TarjetaVistaPrevia(
              emoji: _emojiSeleccionado,
              saludo: _saludoPrevia,
            ),
            const SizedBox(height: 20),
            _Seccion(
              titulo: 'Tu nombre',
              child: TextField(
                controller: _nombreCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '¿Cómo te llamas?',
                  prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _Seccion(
              titulo: 'Tu emoji (selecciona de la lista)',
              child: _SelectorEmoji(
                emojis: _emojis,
                seleccionado: _emojiSeleccionado,
                onSeleccionar: (e) => setState(() => _emojiSeleccionado = e),
              ),
            ),
            const SizedBox(height: 20),
            _Seccion(
              titulo: 'Género',
              child: _SelectorGenero(
                generos: _generos,
                seleccionado: _generoSeleccionado,
                onSeleccionar: (g) => setState(() => _generoSeleccionado = g),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Guardar cambios',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _TarjetaInfo(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta vista previa ────────────────────────────────────────────────
class _TarjetaVistaPrevia extends StatelessWidget {
  final String emoji;
  final String saludo;
  const _TarjetaVistaPrevia({required this.emoji, required this.saludo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Vista previa',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onPrimary.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(emoji, style: TextStyle(fontSize: 56)),
          const SizedBox(height: 8),
          Text(
            saludo,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Así te verás en la app',
            style: TextStyle(fontSize: 13, color: colorScheme.onPrimary.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

// ── Sección con título ───────────────────────────────────────────────
class _Seccion extends StatelessWidget {
  final String titulo;
  final Widget child;
  const _Seccion({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

// ── Selector de emoji ───────────────────────────────────────────────
class _SelectorEmoji extends StatelessWidget {
  final List<String> emojis;
  final String seleccionado;
  final ValueChanged<String> onSeleccionar;
  const _SelectorEmoji({
    required this.emojis,
    required this.seleccionado,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: emojis.length,
        itemBuilder: (_, i) {
          final emoji = emojis[i];
          final activo = emoji == seleccionado;
          return GestureDetector(
            onTap: () => onSeleccionar(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: activo
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: activo
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(emoji, style: TextStyle(fontSize: 26)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Selector de género ───────────────────────────────────────────────
class _SelectorGenero extends StatelessWidget {
  final List<String> generos;
  final String seleccionado;
  final ValueChanged<String> onSeleccionar;

  const _SelectorGenero({
    required this.generos,
    required this.seleccionado,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: generos.map((g) {
        final activo = g == seleccionado;
        return GestureDetector(
          onTap: () => onSeleccionar(g),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: activo
                  ? colorScheme.primary
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: activo
                    ? colorScheme.primary
                    : colorScheme.primary.withValues(alpha: 0.4),
              ),
              boxShadow: activo
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              g,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: activo
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Tarjeta informativa ─────────────────────────────────────────────
class _TarjetaInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                '¿Para qué sirve tu perfil?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoItem(
            icono: '👋',
            texto: 'Personaliza el saludo en la pantalla de inicio',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 8),
          _InfoItem(
            icono: '📊',
            texto: 'Tu género puede usarse en las estadísticas de bienestar',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 8),
          _InfoItem(
            icono: '🔒',
            texto:
                'Todo se guarda localmente en tu dispositivo, sin servidores',
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

// ── Item de info ───────────────────────────────────────────────────
class _InfoItem extends StatelessWidget {
  final String icono;
  final String texto;
  final ColorScheme colorScheme;

  const _InfoItem({
    required this.icono,
    required this.texto,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icono, style: TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}
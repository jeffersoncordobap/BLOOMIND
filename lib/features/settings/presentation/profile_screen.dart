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
    '😊',
    '😎',
    '🌸',
    '🦋',
    '🌟',
    '🎯',
    '🧘',
    '🌈',
    '🦁',
    '🐬',
    '🌻',
    '🎨',
  ];
  static const _generos = [
    'Femenino',
    'Masculino',
    'Otro',
    'Prefiero no decir',
  ];

  late TextEditingController _nombreCtrl;

  late String _emojiSeleccionado;
  late String _generoSeleccionado;

  // Colores de la paleta
  static const _azul = Color(0xFF4A90D9);
  static const _azulSuave = Color(0xFFEEF4FB);
  static const _azulBorde = Color(0xFFB8D4F0);

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileController>().profile;
    _nombreCtrl = TextEditingController(text: profile.nombre); _emojiSeleccionado = profile.emoji;
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Perfil guardado'),
        backgroundColor: _azul,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Saludo dinámico para la vista previa
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
    return Scaffold(
      backgroundColor: _azulSuave,
      appBar: AppBar(
        title: const Text(
          'Perfil local',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _azul,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tarjeta vista previa
            _TarjetaVistaPrevia(
              emoji: _emojiSeleccionado,
              saludo: _saludoPrevia,
            ),
            const SizedBox(height: 20),

            // 2. Campo nombre
            _Seccion(
              titulo: 'Tu nombre',
              child: TextField(
                controller: _nombreCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '¿Cómo te llamas?',
                  prefixIcon: const Icon(Icons.person_outline, color: _azul),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _azulBorde),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _azulBorde),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _azul, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Selector de emoji
            _Seccion(
              titulo: 'Tu emoji (selecciona de la lista)',
              child: Column(
                children: [
                  _SelectorEmoji(                    emojis: _emojis,                   seleccionado: _emojiSeleccionado,                   onSeleccionar: (e) => setState(() => _emojiSeleccionado = e)                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Selector de género
            _Seccion(
              titulo: 'Género',
              child: _SelectorGenero(
                generos: _generos,
                seleccionado: _generoSeleccionado,
                onSeleccionar: (g) => setState(() => _generoSeleccionado = g),
              ),
            ),
            const SizedBox(height: 28),

            // 5. Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _azul,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 6. Tarjeta informativa
            _TarjetaInfo(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta vista previa ──────────────────────────────────────────────────────
class _TarjetaVistaPrevia extends StatelessWidget {
  final String emoji;
  final String saludo;

  const _TarjetaVistaPrevia({required this.emoji, required this.saludo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90D9), Color(0xFF7BB8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x334A90D9),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Vista previa',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 8),
          Text(
            saludo,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Así te verás en la app',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// ── Sección con título ────────────────────────────────────────────────────────
class _Seccion extends StatelessWidget {
  final String titulo;
  final Widget child;

  const _Seccion({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A90D9),
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

// ── Selector de emoji ─────────────────────────────────────────────────────────
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB8D4F0)),
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
                color: activo ? const Color(0xFFDDEEFA) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: activo
                    ? Border.all(color: const Color(0xFF4A90D9), width: 2)
                    : null,
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Selector de género ────────────────────────────────────────────────────────
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
              color: activo ? const Color(0xFF4A90D9) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: activo
                    ? const Color(0xFF4A90D9)
                    : const Color(0xFFB8D4F0),
              ),
              boxShadow: activo
                  ? [
                      const BoxShadow(
                        color: Color(0x334A90D9),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              g,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: activo ? Colors.white : const Color(0xFF4A90D9),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Tarjeta informativa ───────────────────────────────────────────────────────
class _TarjetaInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB8D4F0)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF4A90D9), size: 18),
              SizedBox(width: 8),
              Text(
                '¿Para qué sirve tu perfil?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF4A90D9),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _InfoItem(
            icono: '👋',
            texto: 'Personaliza el saludo en la pantalla de inicio',
          ),
          SizedBox(height: 8),
          _InfoItem(
            icono: '📊',
            texto: 'Tu género puede usarse en las estadísticas de bienestar',
          ),
          SizedBox(height: 8),
          _InfoItem(
            icono: '🔒',
            texto:
                'Todo se guarda localmente en tu dispositivo, sin servidores',
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String icono;
  final String texto;

  const _InfoItem({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icono, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class StatisticsInfoScreen extends StatelessWidget {
  const StatisticsInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2F3A4B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cómo se calculan',
          style: TextStyle(
            color: Color(0xFF2F3A4B),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            children: const [
              _InfoCard(
                icon: '📊',
                title: 'Promedio general',
                description:
                'Calculamos el promedio de todos tus registros del periodo seleccionado. '
                    'Cada emoción tiene un valor: feliz (5), neutral (3), cansado y desmotivado (2), '
                    'triste y enojado (1).',
              ),
              SizedBox(height: 16),
              _InfoCard(
                icon: '🟢',
                title: 'Días positivos',
                description:
                'Contamos los días cuyo promedio emocional fue 3.5 o más.',
              ),
              SizedBox(height: 16),
              _InfoCard(
                icon: '🟡',
                title: 'Días neutros',
                description:
                'Son los días con promedio entre 2.5 y 3.4.',
              ),
              SizedBox(height: 16),
              _InfoCard(
                icon: '🔴',
                title: 'Días negativos',
                description:
                'Son los días con promedio menor a 2.5.',
              ),
              SizedBox(height: 16),
              _InfoCard(
                icon: '🎨',
                title: 'Color de la gráfica',
                description:
                'La gráfica se pinta según el promedio del periodo seleccionado: '
                    'verde cuando va bien (≥ 3.5), amarillo cuando va intermedio (2.5 - 3.4) '
                    'y rojo cuando el promedio está bajo (< 2.5).',
              ),
              SizedBox(height: 18),
              _WhyImportantCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE4E8EE),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF20304A),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF516174),
              fontSize: 16,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyImportantCard extends StatelessWidget {
  const _WhyImportantCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFDDEAF8),
        borderRadius: BorderRadius.circular(22),
      ),
      child:  RichText(
        text: TextSpan(
          style: TextStyle(
            color: Color(0xFF506174),
            fontSize: 16,
            height: 1.5,
          ),
          children: [
            TextSpan(text: '💡 ', style: TextStyle(fontSize: 18)),
            TextSpan(
              text: 'Por qué importa este módulo: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF4C5D70),
              ),
            ),
            TextSpan(
              text:
              'te ayuda a detectar patrones reales en tus días, comparar semanas o meses y '
                  'tomar mejores decisiones sobre descanso, rutina y apoyo.',
            ),
          ],
        ),
      ),
    );
  }
}
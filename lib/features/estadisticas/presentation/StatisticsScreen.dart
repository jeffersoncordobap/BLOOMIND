import 'package:flutter/material.dart';

enum StatisticsPeriod { weekly, monthly }
enum StatisticsChartType { line, bar }

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatisticsPeriod selectedPeriod = StatisticsPeriod.weekly;
  StatisticsChartType selectedChart = StatisticsChartType.bar;

  String selectedPeriodText = '4 de Marzo - 10 de Marzo 2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F3A56),
                ),
              ),
              const SizedBox(height: 18),

              _buildSummaryCard(),

              const SizedBox(height: 18),

              _buildFilterAndChartCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1F8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen semanal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2B44),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '😊 Resumen de tu diario emocional',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF60708A),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  value: '2.6',
                  label: 'Promedio\ngeneral',
                  color: const Color(0xFF1F2B44),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  value: '0',
                  label: 'Días positivos',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  value: '5',
                  label: 'Días neutros',
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  value: '2',
                  label: 'Días negativos',
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF60708A),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterAndChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  text: 'Semanal',
                  selected: selectedPeriod == StatisticsPeriod.weekly,
                  onTap: () {
                    setState(() {
                      selectedPeriod = StatisticsPeriod.weekly;
                      selectedPeriodText = '4 de Marzo - 10 de Marzo 2026';
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildToggleButton(
                  text: 'Mensual',
                  selected: selectedPeriod == StatisticsPeriod.monthly,
                  onTap: () {
                    setState(() {
                      selectedPeriod = StatisticsPeriod.monthly;
                      selectedPeriodText = 'Marzo 2026';
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  text: 'Línea',
                  selected: selectedChart == StatisticsChartType.line,
                  onTap: () {
                    setState(() {
                      selectedChart = StatisticsChartType.line;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildToggleButton(
                  text: 'Barras',
                  selected: selectedChart == StatisticsChartType.bar,
                  onTap: () {
                    setState(() {
                      selectedChart = StatisticsChartType.bar;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _buildPeriodCard(),

          const SizedBox(height: 18),

          _buildFakeChart(),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6D9ED8) : const Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFD8E0EA),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF1F2B44),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Periodo',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF60708A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedPeriodText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2B44),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showWeekDialog(context);
              },
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: const Text(
                'Cambiar periodo',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1F2B44),
                side: const BorderSide(color: Color(0xFFD2DAE5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFakeChart() {
    if (selectedChart == StatisticsChartType.bar) {
      return SizedBox(
        height: 180,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _BarItem(label: 'L', height: 90),
            _BarItem(label: 'M', height: 110),
            _BarItem(label: 'Mi', height: 70),
            _BarItem(label: 'J', height: 120),
            _BarItem(label: 'V', height: 80),
            _BarItem(label: 'S', height: 55),
            _BarItem(label: 'D', height: 95),
          ],
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.show_chart,
            size: 60,
            color: Color(0xFF6D9ED8),
          ),
          const SizedBox(height: 10),
          Text(
            'Aquí irá la gráfica de línea',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _showWeekDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Selecciona un periodo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Más adelante aquí puedes poner un calendario semanal o mensual.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }
}

class _BarItem extends StatelessWidget {
  final String label;
  final double height;

  const _BarItem({
    required this.label,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 22,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF6D9ED8),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF60708A),
          ),
        ),
      ],
    );
  }
}
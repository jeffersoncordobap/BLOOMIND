import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bloomind/features/estadisticas/data/statistics_service.dart';
import 'package:bloomind/features/estadisticas/domain/statistics_model.dart';
import 'statistics_info_screen.dart';
enum StatisticsPeriod { weekly, monthly, daily }
enum StatisticsChartType { line, bar }

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  StatisticsPeriod selectedPeriod = StatisticsPeriod.weekly;
  StatisticsChartType selectedChart = StatisticsChartType.bar;

  late String selectedPeriodText;

  DateTime selectedDailyDate = DateTime.now();
  DateTime selectedWeeklyDate = DateTime.now();
  DateTime selectedMonthlyDate = DateTime.now();

  bool showInlinePicker = false;

  late DateTime tempDailyDate;
  late DateTime tempWeeklyDate;
  late int tempMonth;
  late int tempYear;

  final StatisticsService _statisticsService = StatisticsService();
  StatisticsSummary _statisticsSummary = StatisticsSummary.empty();
  bool _isLoadingStatistics = false;

  @override
  void initState() {
    super.initState();

    selectedPeriodText = _formatWeekRange(selectedWeeklyDate);

    tempDailyDate = selectedDailyDate;
    tempWeeklyDate = selectedWeeklyDate;
    tempMonth = selectedMonthlyDate.month;
    tempYear = selectedMonthlyDate.year;

    _loadStatistics();
  }

  Future<void> refreshStatistics() async {
    await _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoadingStatistics = true);

    StatisticsSummary result;

    if (selectedPeriod == StatisticsPeriod.daily) {
      result = await _statisticsService.getDailyStatistics(selectedDailyDate);
    } else if (selectedPeriod == StatisticsPeriod.weekly) {
      result = await _statisticsService.getWeeklyStatistics(selectedWeeklyDate);
    } else {
      result = await _statisticsService.getMonthlyStatistics(selectedMonthlyDate);
    }

    if (!mounted) return;

    setState(() {
      _statisticsSummary = result;
      _isLoadingStatistics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 8),
               Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
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
    String title;
    switch (selectedPeriod) {
      case StatisticsPeriod.weekly:
        title = 'Resumen semanal';
        break;
      case StatisticsPeriod.monthly:
        title = 'Resumen mensual';
        break;
      case StatisticsPeriod.daily:
        title = 'Resumen diario';
        break;
    }

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
          Text(
            title,
            style: const TextStyle(
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
                  value: _statisticsSummary.averageMood.toStringAsFixed(1),
                  label: 'Promedio\ngeneral',
                  color: const Color(0xFF1F2B44),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  value: '${_statisticsSummary.positiveDays}',
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
                  value: '${_statisticsSummary.neutralDays}',
                  label: 'Días neutros',
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  value: '${_statisticsSummary.negativeDays}',
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
                  onTap: () async {
                    setState(() {
                      selectedPeriod = StatisticsPeriod.weekly;
                      selectedPeriodText = _formatWeekRange(selectedWeeklyDate);
                      showInlinePicker = false;
                    });
                    await _loadStatistics();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildToggleButton(
                  text: 'Mensual',
                  selected: selectedPeriod == StatisticsPeriod.monthly,
                  onTap: () async {
                    setState(() {
                      selectedPeriod = StatisticsPeriod.monthly;
                      selectedPeriodText = _formatMonthYear(selectedMonthlyDate);
                      showInlinePicker = false;
                    });
                    await _loadStatistics();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildToggleButton(
                  text: 'Diario',
                  selected: selectedPeriod == StatisticsPeriod.daily,
                  onTap: () async {
                    setState(() {
                      selectedPeriod = StatisticsPeriod.daily;
                      selectedPeriodText = _formatDate(selectedDailyDate);
                      showInlinePicker = false;
                    });
                    await _loadStatistics();
                  },
                ),
              ),
            ],
          ),
          if (selectedPeriod != StatisticsPeriod.daily) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    text: 'Línea',
                    selected: selectedChart == StatisticsChartType.line,
                    onTap: () {
                      setState(() => selectedChart = StatisticsChartType.line);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildToggleButton(
                    text: 'Barras',
                    selected: selectedChart == StatisticsChartType.bar,
                    onTap: () {
                      setState(() => selectedChart = StatisticsChartType.bar);
                    },
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          _buildPeriodCard(),
          if (showInlinePicker) ...[
            const SizedBox(height: 18),
            _buildInlinePicker(),
          ],
          const SizedBox(height: 18),
          _buildChartArea(),
          const SizedBox(height: 18),

          Material(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StatisticsInfoScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '¿Cómo se calculan las estadísticas?',
                        style: TextStyle(fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface
                        ),
                        
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          border: Border.all(color: const Color(0xFFD8E0EA)),
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
                setState(() {
                  if (selectedPeriod == StatisticsPeriod.daily) {
                    _prepareDailyPicker();
                  } else if (selectedPeriod == StatisticsPeriod.weekly) {
                    _prepareWeeklyPicker();
                  } else {
                    _prepareMonthlyPicker();
                  }
                  showInlinePicker = true;
                });
              },
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: const Text(
                'Cambiar periodo',
                style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildInlinePicker() {
    switch (selectedPeriod) {
      case StatisticsPeriod.weekly:
        return _buildWeeklyPickerCard();
      case StatisticsPeriod.monthly:
        return _buildMonthlyPickerCard();
      case StatisticsPeriod.daily:
        return _buildDailyPickerCard();
    }
  }

  Widget _buildChartArea() {
    if (selectedPeriod == StatisticsPeriod.daily) {
      return _buildDailyAverageCard();
    }

    if (_isLoadingStatistics) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_statisticsSummary.chartPoints.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Text('No hay datos para este periodo'),
        ),
      );
    }

    if (selectedChart == StatisticsChartType.bar) {
      return _buildBarChart();
    }

    return _buildLineChart();
  }

  Widget _buildBarChart() {
    final points = _statisticsSummary.chartPoints;
    final bool isMonthly = selectedPeriod == StatisticsPeriod.monthly;

    final double chartWidth = isMonthly
        ? (points.length * 26).clamp(320, 1200).toDouble()
        : MediaQuery.of(context).size.width - 70;

    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD8E0EA)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: 6,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: const Color(0xFFD9E1EA),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
                getDrawingVerticalLine: (_) => FlLine(
                  color: const Color(0xFFE5EAF0),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Color(0xFF8A97AB), width: 1),
                  bottom: BorderSide(color: Color(0xFF8A97AB), width: 1),
                  right: BorderSide.none,
                  top: BorderSide.none,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == 2 || value == 5) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF60708A),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          points[index].label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF60708A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipRoundedRadius: 16,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  tooltipMargin: 8,
                  getTooltipColor: (_) => Colors.white,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final point = points[group.x.toInt()];
                    final dateText = _getTooltipDate(point.label);
                    final description = _getPointDescription(point.value);

                    return BarTooltipItem(
                      '$dateText\nPromedio: ${point.value.toStringAsFixed(1)}\n$description',
                      const TextStyle(
                        color: Color(0xFF1F2B44),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    );
                  },
                ),
              ),
              barGroups: List.generate(points.length, (index) {
                final point = points[index];

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: point.value,
                      width: isMonthly ? 10 : 18,
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFFE0AA00),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final points = _statisticsSummary.chartPoints;
    final bool isMonthly = selectedPeriod == StatisticsPeriod.monthly;

    final double chartWidth = isMonthly
        ? (points.length * 30).clamp(320, 1400).toDouble()
        : MediaQuery.of(context).size.width - 70;

    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD8E0EA)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 6,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: const Color(0xFFD9E1EA),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
                getDrawingVerticalLine: (_) => FlLine(
                  color: const Color(0xFFE5EAF0),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Color(0xFF8A97AB), width: 1),
                  bottom: BorderSide(color: Color(0xFF8A97AB), width: 1),
                  right: BorderSide.none,
                  top: BorderSide.none,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == 2 || value == 5) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF60708A),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          points[index].label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF60708A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipRoundedRadius: 16,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  tooltipMargin: 8,
                  getTooltipColor: (_) => Colors.white,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final point = points[spot.x.toInt()];
                      final dateText = _getTooltipDate(point.label);
                      final description = _getPointDescription(point.value);

                      return LineTooltipItem(
                        '$dateText\nPromedio: ${point.value.toStringAsFixed(1)}\n$description',
                        const TextStyle(
                          color: Color(0xFF1F2B44),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(points.length, (index) {
                    return FlSpot(index.toDouble(), points[index].value);
                  }),
                  isCurved: false,
                  barWidth: 2.5,
                  color: const Color(0xFFE0AA00),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: const Color(0xFFE0AA00),
                        strokeWidth: 1,
                        strokeColor: const Color(0xFFE0AA00),
                      );
                    },
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _currentWeekStart => _startOfWeek(_today);

  DateTime get _currentMonthStart => DateTime(_today.year, _today.month, 1);

  bool _canMoveToNextWeeklyMonth() {
    final nextMonthDate = DateTime(
      tempWeeklyDate.year,
      tempWeeklyDate.month + 1,
      tempWeeklyDate.day,
    );

    final nextMonthStart = DateTime(nextMonthDate.year, nextMonthDate.month, 1);
    return !nextMonthStart.isAfter(_currentMonthStart);
  }

  bool _canMoveToNextDailyMonth() {
    final nextMonthDate = DateTime(
      tempDailyDate.year,
      tempDailyDate.month + 1,
      tempDailyDate.day,
    );

    final nextMonthStart = DateTime(nextMonthDate.year, nextMonthDate.month, 1);
    return !nextMonthStart.isAfter(_currentMonthStart);
  }

  bool _canMoveToNextMonthlyMonth() {
    final nextMonthStart = tempMonth == 12
        ? DateTime(tempYear + 1, 1, 1)
        : DateTime(tempYear, tempMonth + 1, 1);

    return !nextMonthStart.isAfter(_currentMonthStart);
  }

  bool _canGoToNextYear() {
    final nextYearSameMonth = DateTime(tempYear + 1, tempMonth, 1);
    return !nextYearSameMonth.isAfter(_currentMonthStart);
  }

  bool _isFutureWeek(DateTime date) {
    return _startOfWeek(date).isAfter(_currentWeekStart);
  }

  bool _isFutureMonth(int year, int month) {
    final selectedMonth = DateTime(year, month, 1);
    return selectedMonth.isAfter(_currentMonthStart);
  }

  bool _isFutureDay(DateTime date) {
    return date.isAfter(_today);
  }

  String _getTooltipDate(String label) {
    if (selectedPeriod == StatisticsPeriod.weekly) {
      final start = _startOfWeek(selectedWeeklyDate);

      final Map<String, int> dayOffset = {
        'D': 0,
        'L': 1,
        'M': 2,
        'Mi': 3,
        'J': 4,
        'V': 5,
        'S': 6,
      };

      final offset = dayOffset[label] ?? 0;
      final date = start.add(Duration(days: offset));
      return _formatDate(date);
    }

    if (selectedPeriod == StatisticsPeriod.monthly) {
      final day = int.tryParse(label) ?? 1;
      final date =
      DateTime(selectedMonthlyDate.year, selectedMonthlyDate.month, day);
      return _formatDate(date);
    }

    return label;
  }

  String _getPointDescription(double value) {
    if (value == 0) {
      return 'Sin registros';
    } else if (value < 2.5) {
      return 'Día Negativo';
    } else if (value < 3.5) {
      return 'Día Neutro';
    } else {
      return 'Día Positivo';
    }
  }

  Widget _buildDailyAverageCard() {
    if (_isLoadingStatistics) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF6D9ED8),
            size: 34,
          ),
          const SizedBox(height: 12),
          const Text(
            'Promedio del día seleccionado',
            style: TextStyle(fontSize: 16, color: Color(0xFF60708A)),
          ),
          const SizedBox(height: 10),
          Text(
            _formatDate(selectedDailyDate),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2B44),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _statisticsSummary.dailyAverage.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2B44),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Estado emocional promedio del día',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF60708A)),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyPickerCard() {
    final visibleMonth = DateTime(tempWeeklyDate.year, tempWeeklyDate.month, 1);
    final days = _buildCalendarDays(visibleMonth);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD8E0EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona una semana',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2B44),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFD8E0EA)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _circleNavButton(
                      icon: Icons.chevron_left,
                      onTap: () {
                        setState(() {
                          tempWeeklyDate = DateTime(
                            tempWeeklyDate.year,
                            tempWeeklyDate.month - 1,
                            tempWeeklyDate.day,
                          );
                        });
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _formatMonthYearLower(tempWeeklyDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2B44),
                          ),
                        ),
                      ),
                    ),
                    _circleNavButton(
                      icon: Icons.chevron_right,
                      onTap: _canMoveToNextWeeklyMonth()
                          ? () {
                        setState(() {
                          tempWeeklyDate = DateTime(
                            tempWeeklyDate.year,
                            tempWeeklyDate.month + 1,
                            tempWeeklyDate.day,
                          );
                        });
                      }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _WeekDayLabel('D'),
                    _WeekDayLabel('L'),
                    _WeekDayLabel('M'),
                    _WeekDayLabel('Mi'),
                    _WeekDayLabel('J'),
                    _WeekDayLabel('V'),
                    _WeekDayLabel('S'),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final date = days[index];
                    final belongsToMonth = date.month == visibleMonth.month;
                    final selectedWeekStart = _startOfWeek(tempWeeklyDate);
                    final selectedWeekEnd =
                    selectedWeekStart.add(const Duration(days: 6));
                    final isInSelectedWeek = !date.isBefore(selectedWeekStart) &&
                        !date.isAfter(selectedWeekEnd);
                    final isFutureWeek = _isFutureWeek(date);

                    return GestureDetector(
                      onTap: isFutureWeek
                          ? null
                          : () {
                        setState(() {
                          tempWeeklyDate = date;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isInSelectedWeek
                              ? const Color(0xFFDCE9F9)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isFutureWeek
                                ? const Color(0xFFB8C2D1)
                                : belongsToMonth
                                ? const Color(0xFF1F2B44)
                                : const Color(0xFF8A97AB),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: Color(0xFF60708A)),
                children: [
                  const TextSpan(text: 'Semana seleccionada: '),
                  TextSpan(
                    text: _formatWeekRange(tempWeeklyDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2B44),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  text: 'Aplicar',
                  filled: true,
                  onTap: () => _applyWeeklySelection(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                  text: 'Cancelar',
                  filled: false,
                  onTap: _cancelInlinePicker,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyPickerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD8E0EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona un mes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2B44),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Año',
            style: TextStyle(fontSize: 14, color: Color(0xFF60708A)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _circleNavButton(
                icon: Icons.chevron_left,
                onTap: () => setState(() => tempYear--),
              ),
              const SizedBox(width: 10),
              Expanded(child: _selectionBox('$tempYear')),
              const SizedBox(width: 10),
              _circleNavButton(
                icon: Icons.chevron_right,
                onTap: _canGoToNextYear()
                    ? () {
                  setState(() {
                    tempYear++;
                  });
                }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Mes',
            style: TextStyle(fontSize: 14, color: Color(0xFF60708A)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _circleNavButton(
                icon: Icons.chevron_left,
                onTap: () {
                  setState(() {
                    if (tempMonth == 1) {
                      tempMonth = 12;
                      tempYear--;
                    } else {
                      tempMonth--;
                    }
                  });
                },
              ),
              const SizedBox(width: 10),
              Expanded(child: _selectionBox(_monthNameCapitalized(tempMonth))),
              const SizedBox(width: 10),
              _circleNavButton(
                icon: Icons.chevron_right,
                onTap: _canMoveToNextMonthlyMonth()
                    ? () {
                  setState(() {
                    if (tempMonth == 12) {
                      tempMonth = 1;
                      tempYear++;
                    } else {
                      tempMonth++;
                    }
                  });
                }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: Color(0xFF60708A)),
                children: [
                  const TextSpan(text: 'Mes seleccionado: '),
                  TextSpan(
                    text: '${_monthNameCapitalized(tempMonth)} de $tempYear',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2B44),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  text: 'Aplicar',
                  filled: true,
                  onTap: () => _applyMonthlySelection(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                  text: 'Cancelar',
                  filled: false,
                  onTap: _cancelInlinePicker,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyPickerCard() {
    final visibleMonth = DateTime(tempDailyDate.year, tempDailyDate.month, 1);
    final days = _buildCalendarDays(visibleMonth);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD8E0EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona un día',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2B44),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFD8E0EA)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _circleNavButton(
                      icon: Icons.chevron_left,
                      onTap: () {
                        setState(() {
                          tempDailyDate = DateTime(
                            tempDailyDate.year,
                            tempDailyDate.month - 1,
                            tempDailyDate.day,
                          );
                        });
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _formatMonthYearLower(tempDailyDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2B44),
                          ),
                        ),
                      ),
                    ),
                    _circleNavButton(
                      icon: Icons.chevron_right,
                      onTap: _canMoveToNextDailyMonth()
                          ? () {
                        setState(() {
                          tempDailyDate = DateTime(
                            tempDailyDate.year,
                            tempDailyDate.month + 1,
                            tempDailyDate.day,
                          );
                        });
                      }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _WeekDayLabel('D'),
                    _WeekDayLabel('L'),
                    _WeekDayLabel('M'),
                    _WeekDayLabel('Mi'),
                    _WeekDayLabel('J'),
                    _WeekDayLabel('V'),
                    _WeekDayLabel('S'),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final date = days[index];
                    final belongsToMonth = date.month == visibleMonth.month;
                    final isSelected = _isSameDate(date, tempDailyDate);
                    final isFutureDay = _isFutureDay(date);

                    return GestureDetector(
                      onTap: isFutureDay
                          ? null
                          : () {
                        setState(() {
                          tempDailyDate = date;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFDCE9F9)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isFutureDay
                                ? const Color(0xFFB8C2D1)
                                : belongsToMonth
                                ? const Color(0xFF1F2B44)
                                : const Color(0xFF8A97AB),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: Color(0xFF60708A)),
                children: [
                  const TextSpan(text: 'Día seleccionado: '),
                  TextSpan(
                    text: _formatDate(tempDailyDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2B44),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  text: 'Aplicar',
                  filled: true,
                  onTap: () => _applyDailySelection(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton(
                  text: 'Cancelar',
                  filled: false,
                  onTap: _cancelInlinePicker,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleNavButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final bool isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isEnabled
              ? const Color(0xFFF0F4F8)
              : const Color(0xFFF6F8FB),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD8E0EA)),
        ),
        child: Icon(
          icon,
          color: isEnabled
              ? const Color(0xFF1F2B44)
              : const Color(0xFFB8C2D1),
        ),
      ),
    );
  }

  Widget _selectionBox(String text) {
    return Container(
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2B44),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 46,
      child: filled
          ? ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6D9ED8),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      )
          : OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1F2B44),
          side: const BorderSide(color: Color(0xFFD8E0EA)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _prepareDailyPicker() => tempDailyDate = selectedDailyDate;

  void _prepareWeeklyPicker() => tempWeeklyDate = selectedWeeklyDate;

  void _prepareMonthlyPicker() {
    tempMonth = selectedMonthlyDate.month;
    tempYear = selectedMonthlyDate.year;
  }

  Future<void> _applyDailySelection() async {
    if (_isFutureDay(tempDailyDate)) return;

    setState(() {
      selectedDailyDate = tempDailyDate;
      selectedPeriodText = _formatDate(selectedDailyDate);
      showInlinePicker = false;
    });

    await _loadStatistics();
  }

  Future<void> _applyWeeklySelection() async {
    if (_isFutureWeek(tempWeeklyDate)) return;

    setState(() {
      selectedWeeklyDate = tempWeeklyDate;
      selectedPeriodText = _formatWeekRange(selectedWeeklyDate);
      showInlinePicker = false;
    });

    await _loadStatistics();
  }

  Future<void> _applyMonthlySelection() async {
    if (_isFutureMonth(tempYear, tempMonth)) return;

    setState(() {
      selectedMonthlyDate = DateTime(tempYear, tempMonth, 1);
      selectedPeriodText = _formatMonthYear(selectedMonthlyDate);
      showInlinePicker = false;
    });

    await _loadStatistics();
  }

  void _cancelInlinePicker() => setState(() => showInlinePicker = false);

  List<DateTime> _buildCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final firstWeekday = firstDay.weekday % 7;
    final startDate = firstDay.subtract(Duration(days: firstWeekday));
    return List.generate(42, (index) => startDate.add(Duration(days: index)));
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final daysFromSunday = normalized.weekday % 7;
    return normalized.subtract(Duration(days: daysFromSunday));
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDate(DateTime date) =>
      '${date.day} de ${_monthNameLower(date.month)} ${date.year}';

  String _formatWeekRange(DateTime date) {
    final start = _startOfWeek(date);
    final end = start.add(const Duration(days: 6));
    return '${start.day} de ${_monthNameCapitalized(start.month)} - ${end.day} de ${_monthNameCapitalized(end.month)} ${end.year}';
  }

  String _formatMonthYear(DateTime date) =>
      '${_monthNameCapitalized(date.month)} de ${date.year}';

  String _formatMonthYearLower(DateTime date) =>
      '${_monthNameLower(date.month)} ${date.year}';

  String _monthNameLower(int month) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return months[month - 1];
  }

  String _monthNameCapitalized(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month - 1];
  }
}

class _WeekDayLabel extends StatelessWidget {
  final String text;

  const _WeekDayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF60708A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
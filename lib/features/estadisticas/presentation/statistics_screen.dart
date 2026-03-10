import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:bloomind/features/estadisticas/data/statistics_service.dart';
import 'package:bloomind/features/estadisticas/domain/statistics_model.dart';
enum StatisticsPeriod { weekly, monthly, daily }
enum StatisticsChartType { line, bar }
final StatisticsService _statisticsService = StatisticsService();


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatisticsPeriod selectedPeriod = StatisticsPeriod.weekly;
  StatisticsChartType selectedChart = StatisticsChartType.bar;

  final StatisticsService _statisticsService = StatisticsService();

  StatisticsSummary _statisticsSummary = StatisticsSummary.empty();
  bool _isLoadingStatistics = false;

  late String selectedPeriodText;

  DateTime selectedDailyDate = DateTime.now();
  DateTime selectedWeeklyDate = DateTime.now();
  DateTime selectedMonthlyDate = DateTime.now();

  bool showInlinePicker = false;

  late DateTime tempDailyDate;
  late DateTime tempWeeklyDate;
  late int tempMonth;
  late int tempYear;

  @override
  void initState() {
    super.initState();
    selectedPeriodText = _formatWeekRange(selectedWeeklyDate);

    tempDailyDate = selectedDailyDate;
    tempWeeklyDate = selectedWeeklyDate;
    tempMonth = selectedMonthlyDate.month;
    tempYear = selectedMonthlyDate.year;

    _loadDailyStatistics();
  }
  Future<void> _loadDailyStatistics() async {
    setState(() {
      _isLoadingStatistics = true;
    });

    final result = await _statisticsService.getDailyStatistics(selectedDailyDate);

    setState(() {
      _statisticsSummary = result;
      _isLoadingStatistics = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
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
                      selectedPeriodText = _formatWeekRange(selectedWeeklyDate);
                      showInlinePicker = false;
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
                      selectedPeriodText = _formatMonthYear(selectedMonthlyDate);
                      showInlinePicker = false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildToggleButton(
                  text: 'Diario',
                  selected: selectedPeriod == StatisticsPeriod.daily,
                  onTap: () {
                    setState(() {
                      selectedPeriod = StatisticsPeriod.daily;
                      selectedPeriodText = _formatDate(selectedDailyDate);
                      showInlinePicker = false;
                    });
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
          ],
          const SizedBox(height: 18),
          _buildPeriodCard(),
          if (showInlinePicker) ...[
            const SizedBox(height: 18),
            _buildInlinePicker(),
          ],
          const SizedBox(height: 18),
          _buildChartArea(),
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
                      onTap: () {
                        setState(() {
                          tempWeeklyDate = DateTime(
                            tempWeeklyDate.year,
                            tempWeeklyDate.month + 1,
                            tempWeeklyDate.day,
                          );
                        });
                      },
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

                    return GestureDetector(
                      onTap: () {
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
                            color: belongsToMonth
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
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF60708A),
                ),
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
                  onTap: _applyWeeklySelection,
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
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF60708A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _circleNavButton(
                icon: Icons.chevron_left,
                onTap: () {
                  setState(() {
                    tempYear--;
                  });
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _selectionBox('$tempYear'),
              ),
              const SizedBox(width: 10),
              _circleNavButton(
                icon: Icons.chevron_right,
                onTap: () {
                  setState(() {
                    tempYear++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Mes',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF60708A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _circleNavButton(
                icon: Icons.chevron_left,
                onTap: () {
                  setState(() {
                    tempMonth = tempMonth == 1 ? 12 : tempMonth - 1;
                  });
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _selectionBox(_monthNameCapitalized(tempMonth)),
              ),
              const SizedBox(width: 10),
              _circleNavButton(
                icon: Icons.chevron_right,
                onTap: () {
                  setState(() {
                    tempMonth = tempMonth == 12 ? 1 : tempMonth + 1;
                  });
                },
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
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF60708A),
                ),
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
                  onTap: _applyMonthlySelection,
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
                      onTap: () {
                        setState(() {
                          tempDailyDate = DateTime(
                            tempDailyDate.year,
                            tempDailyDate.month + 1,
                            tempDailyDate.day,
                          );
                        });
                      },
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

                    return GestureDetector(
                      onTap: () {
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
                            color: belongsToMonth
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
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF60708A),
                ),
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
                  onTap: () {
                    _applyDailySelection();
                  },
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

  Widget _buildChartArea() {
    if (selectedPeriod == StatisticsPeriod.daily) {
      return _buildDailyAverageCard();
    }

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

  Widget _buildDailyAverageCard() {
    Widget _buildDailyAverageCard() {
      if (_isLoadingStatistics) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
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
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF60708A),
              ),
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
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF60708A),
              ),
            ),
          ],
        ),
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
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF60708A),
            ),
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
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF60708A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD8E0EA)),
        ),
        child: Icon(icon, color: const Color(0xFF1F2B44)),
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

  void _prepareDailyPicker() {
    tempDailyDate = selectedDailyDate;
  }

  void _prepareWeeklyPicker() {
    tempWeeklyDate = selectedWeeklyDate;
  }

  void _prepareMonthlyPicker() {
    tempMonth = selectedMonthlyDate.month;
    tempYear = selectedMonthlyDate.year;
  }

  Future<void> _applyDailySelection() async {
    setState(() {
      selectedDailyDate = tempDailyDate;
      selectedPeriodText = _formatDate(selectedDailyDate);
      showInlinePicker = false;
    });

    await _loadDailyStatistics();
  }

  void _applyWeeklySelection() {
    setState(() {
      selectedWeeklyDate = tempWeeklyDate;
      selectedPeriodText = _formatWeekRange(selectedWeeklyDate);
      showInlinePicker = false;
    });
  }

  void _applyMonthlySelection() {
    setState(() {
      selectedMonthlyDate = DateTime(tempYear, tempMonth, 1);
      selectedPeriodText = _formatMonthYear(selectedMonthlyDate);
      showInlinePicker = false;
    });
  }

  void _cancelInlinePicker() {
    setState(() {
      showInlinePicker = false;
    });
  }

  List<DateTime> _buildCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final firstWeekday = firstDay.weekday % 7;
    final startDate = firstDay.subtract(Duration(days: firstWeekday));

    final totalDays = 42;
    return List.generate(
      totalDays,
          (index) => startDate.add(Duration(days: index)),
    );
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final daysFromSunday = normalized.weekday % 7;
    return normalized.subtract(Duration(days: daysFromSunday));
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    return '${date.day} de ${_monthNameLower(date.month)} ${date.year}';
  }

  String _formatWeekRange(DateTime date) {
    final start = _startOfWeek(date);
    final end = start.add(const Duration(days: 6));
    return '${start.day} de ${_monthNameCapitalized(start.month)} - ${end.day} de ${_monthNameCapitalized(end.month)} ${end.year}';
  }

  String _formatMonthYear(DateTime date) {
    return '${_monthNameCapitalized(date.month)} de ${date.year}';
  }

  String _formatMonthYearLower(DateTime date) {
    return '${_monthNameLower(date.month)} ${date.year}';
  }

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
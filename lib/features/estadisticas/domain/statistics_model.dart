class StatisticsSummary {
  final double averageMood;
  final int positiveDays;
  final int neutralDays;
  final int negativeDays;
  final double dailyAverage;
  final List<ChartPoint> chartPoints;

  StatisticsSummary({
    required this.averageMood,
    required this.positiveDays,
    required this.neutralDays,
    required this.negativeDays,
    required this.dailyAverage,
    required this.chartPoints,
  });

  factory StatisticsSummary.empty() {
    return StatisticsSummary(
      averageMood: 0.0,
      positiveDays: 0,
      neutralDays: 0,
      negativeDays: 0,
      dailyAverage: 0.0,
      chartPoints: [],
    );
  }
}

class ChartPoint {
  final String label;
  final double value;

  ChartPoint({
    required this.label,
    required this.value,
  });
}
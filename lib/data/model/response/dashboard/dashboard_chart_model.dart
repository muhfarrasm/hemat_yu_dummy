class MonthlyChartData {
  final String period;
  final double pemasukan;
  final double pengeluaran;
  final double saldo;
  final bool isCurrent;

  MonthlyChartData({
    required this.period,
    required this.pemasukan,
    required this.pengeluaran,
    required this.saldo,
    required this.isCurrent,
  });

  factory MonthlyChartData.fromJson(Map<String, dynamic> json) {
    return MonthlyChartData(
      period: json['period'],
      pemasukan: (json['pemasukan'] ?? 0).toDouble(),
      pengeluaran: (json['pengeluaran'] ?? 0).toDouble(),
      saldo: (json['saldo'] ?? 0).toDouble(),
      isCurrent: json['is_current'] ?? false,
    );
  }

  /// Ambil singkatan bulan dari period, e.g. "Aug 2024" -> "Aug"
  String get monthLabel {
    final parts = period.split(' ');
    return parts.isNotEmpty ? parts[0] : period;
  }
}

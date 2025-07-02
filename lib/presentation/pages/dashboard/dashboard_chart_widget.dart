// lib/presentation/pages/dashboard/dashboard_chart_widget.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/dashboard_chart_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/pengeluaran_kategori_chart_model.dart';

class DashboardChartWidget extends StatelessWidget {
  final List<MonthlyChartData> monthlyData;
  final List<PengeluaranKategoriChartModel> kategoriData;

  const DashboardChartWidget({
    super.key,
    required this.monthlyData,
    required this.kategoriData,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> pieColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.pink,
      Colors.cyan,
      Colors.indigo,
    ];
    return Column(
      children: [
        /// ---- Bar Chart ----
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            '📊 Pemasukan & Pengeluaran Bulanan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        AspectRatio(
          aspectRatio: 1.8, // Lebar
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < monthlyData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            monthlyData[index].monthLabel,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 28,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    interval: 50000000, // contoh: setiap 50jt
                    getTitlesWidget: (value, meta) {
                      String text;
                      if (value >= 1000000000) {
                        text = '${(value / 1000000000).toStringAsFixed(1)}M';
                      } else if (value >= 1000000) {
                        text = '${(value / 1000000).toStringAsFixed(0)}jt';
                      } else {
                        text = value.toInt().toString();
                      }
                      return Text(text, style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),

                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups:
                  monthlyData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data.pemasukan,
                          color: Colors.green,
                          width: 8,
                        ),
                        BarChartRodData(
                          toY: data.pengeluaran,
                          color: Colors.red,
                          width: 8,
                        ),
                      ],
                      barsSpace: 4,
                    );
                  }).toList(),
            ),
          ),
        ),

        /// ---- Pie Chart ----
        const Padding(
          padding: EdgeInsets.only(top: 32, bottom: 12),
          child: Text(
            ' Pengeluaran Berdasarkan Kategori',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        kategoriData.isEmpty
            ? const Text('Tidak ada data kategori pengeluaran untuk bulan ini.')
            : AspectRatio(
              aspectRatio: 1.4,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections:
                      kategoriData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final e = entry.value;
                        return PieChartSectionData(
                          value: e.totalAmount,
                          title: e.categoryName,
                          radius: 50,
                          color:
                              pieColors[index %
                                  pieColors.length], // 👈 warna beda
                        );
                      }).toList(),
                ),
              ),
            ),
      ],
    );
  }
}

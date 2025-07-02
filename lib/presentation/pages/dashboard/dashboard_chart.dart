import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Grafik Pengeluaran per Kategori',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: 40,
                      title: 'Makan',
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 30,
                      title: 'Transport',
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: 20,
                      title: 'Hiburan',
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: 10,
                      title: 'Lainnya',
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

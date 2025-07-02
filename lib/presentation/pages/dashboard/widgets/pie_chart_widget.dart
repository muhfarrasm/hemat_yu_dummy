import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/chart/ringkasan_katpeng_pie_response.dart';

class PieChartWidget extends StatelessWidget {
  final RingkasanKatPengPieResponse data;

  const PieChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.data == null || data.data!.isEmpty) {
      return const Text('Tidak ada data kategori.');
    }

    final sections = data.data!
        .asMap()
        .map<int, PieChartSectionData>((index, kat) {
          return MapEntry(
            index,
            PieChartSectionData(
              color: Colors.primaries[index % Colors.primaries.length],
              value: kat.totalAmount ?? 0,
              title: '${kat.categoryName}\n${kat.totalAmount?.toStringAsFixed(0)}',
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          );
        })
        .values
        .toList();

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}

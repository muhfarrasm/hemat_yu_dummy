import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/chart/harian_katpeng_line_response.dart';

class LineChartWidget extends StatelessWidget {
  final HarianKatPengLineResponse data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final dailyData = data.data?.dailyData ?? {};

    final spots = dailyData.entries.map((entry) {
      return FlSpot(
        double.parse(entry.key),
        entry.value.toDouble(),
      );
    }).toList();

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primaryColor,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.3),
                    AppColors.primaryColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

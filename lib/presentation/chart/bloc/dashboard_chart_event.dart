part of 'dashboard_chart_bloc.dart';

abstract class DashboardChartEvent {}

class FetchDashboardCharts extends DashboardChartEvent {
  final int month;
  final int year;

  FetchDashboardCharts({required this.month, required this.year});
}



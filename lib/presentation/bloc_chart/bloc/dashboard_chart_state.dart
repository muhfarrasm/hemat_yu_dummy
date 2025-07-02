part of 'dashboard_chart_bloc.dart';

abstract class DashboardChartState {}

class DashboardChartInitial extends DashboardChartState {}

class DashboardChartLoading extends DashboardChartState {}

class DashboardChartLoaded extends DashboardChartState {
  final List<MonthlyChartData> monthlyData;
  final List<PengeluaranKategoriChartModel> kategoriData;

  DashboardChartLoaded(this.monthlyData, this.kategoriData);
}

class DashboardChartError extends DashboardChartState {
  final String message;
  DashboardChartError(this.message);
}

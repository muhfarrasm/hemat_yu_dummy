import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/dashboard_chart_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/pengeluaran_kategori_chart_model.dart';
import 'package:hematyu_app_dummy_fix/data/repository/dashboard_repository.dart';

part 'dashboard_chart_event.dart';
part 'dashboard_chart_state.dart';

class DashboardChartBloc extends Bloc<DashboardChartEvent, DashboardChartState> {
  final DashboardRepository repository;

  DashboardChartBloc(this.repository) : super(DashboardChartInitial()) {
    on<FetchDashboardCharts>((event, emit) async {
      emit(DashboardChartLoading());
      try {
        final monthlyData = await repository.getMonthlyChartData();
        final kategoriData = await repository.getPengeluaranKategoriChart(event.month, event.year);

        print('📊 Loaded monthlyData: ${monthlyData.length}');
        print('🍕 Loaded kategoriData: ${kategoriData.length}');

        emit(DashboardChartLoaded(monthlyData, kategoriData));
      } catch (e) {
        print('❌ Error loading charts: $e');
        emit(DashboardChartError(e.toString()));
      }
    });
  }
}

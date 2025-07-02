import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/bloc_chart/bloc/dashboard_chart_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_state.dart';
import 'package:hematyu_app_dummy_fix/data/repository/dashboard_repository.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/dashboard/dashboard_chart_widget.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardRepository = DashboardRepository(ServiceHttpClient());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardBloc(dashboardRepository)..add(FetchDashboardEvent()),
        ),
        BlocProvider(
          create: (_) {
            final now = DateTime.now();
            return DashboardChartBloc(dashboardRepository)
              ..add(FetchDashboardCharts(month: now.month, year: now.year));
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardLoaded) {
                    final user = state.userResponse.user;
                    final stats = state.userResponse.stats;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Halo, ${user.username} 👋",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text("Saldo saat ini:", style: TextStyle(fontSize: 16)),
                        Text(formatter.format(stats.sisaSaldo),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                        const SizedBox(height: 24),
                      ],
                    );
                  } else if (state is DashboardError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  return const SizedBox.shrink();
                },
              ),

              /// Chart Section
              BlocBuilder<DashboardChartBloc, DashboardChartState>(
                builder: (context, state) {
                  if (state is DashboardChartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardChartLoaded) {
                    return DashboardChartWidget(
                      monthlyData: state.monthlyData,
                      kategoriData: state.kategoriData,
                    );
                  } else if (state is DashboardChartError) {
                    return Text("Gagal memuat grafik: ${state.message}");
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

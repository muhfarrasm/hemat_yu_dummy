import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/chart/bloc/chart_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/dashboard/widgets/line_chart_widget.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/dashboard/widgets/pie_chart_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardLoaded) {
                    final username = state.profile.data?.user?.username ?? '-';
                    final saldo = state.profile.data?.stats?.sisaSaldo ?? 0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $username!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Saldo saat ini:',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Rp $saldo',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else if (state is DashboardError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<ChartBloc, ChartState>(
                builder: (context, state) {
                  if (state is ChartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChartLoadedPie) {
                    return PieChartWidget(data: state.pieData);
                  } else if (state is ChartError) {
                    return Text('Pie Chart Error: ${state.message}');
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<ChartBloc, ChartState>(
                builder: (context, state) {
                  if (state is ChartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChartLoadedLine) {
                    return LineChartWidget(data: state.lineData);
                  } else if (state is ChartError) {
                    return Text('Line Chart Error: ${state.message}');
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cetak laporan coming soon!'),
                    ),
                  );
                },
                child: const Text('Cetak Laporan PDF/Excel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

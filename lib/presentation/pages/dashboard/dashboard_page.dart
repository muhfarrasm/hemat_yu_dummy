import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';
import 'package:hematyu_app_dummy_fix/presentation/auth/login_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/chart/bloc/dashboard_chart_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_state.dart';
import 'package:hematyu_app_dummy_fix/data/repository/dashboard_repository.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/dashboard/dashboard_chart_widget.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  final formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardRepository = DashboardRepository(ServiceHttpClient());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final now = DateTime.now();
            return DashboardChartBloc(dashboardRepository)
              ..add(FetchDashboardCharts(month: now.month, year: now.year));
          },
        ),
        BlocProvider(
          // Menginisialisasi DashboardBloc dan memicu FetchDashboardEvent
          create:
              (_) =>
                  DashboardBloc(dashboardRepository)
                    ..add(FetchDashboardEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutConfirmationDialog(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section & Quick Stats Section
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardAllLoaded) {
                    // Menggunakan DashboardAllLoaded
                    final user = state.userResponse.user;
                    final stats = state.userResponse.stats;
                    final summary =
                        state.targetSummary; // Mendapatkan summary dari state
                    final percentage =
                        summary
                            .percentageCollected; // Perbaikan persentase di sini

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          20, // setengah dari width/height yang diinginkan
                                      backgroundImage: AssetImage(
                                        'assets/images/luffy.jpg',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Halo, ${user.username}!",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Selamat datang kembali",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Saldo Saat Ini",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatter.format(stats.sisaSaldo),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Quick Stats Section
                        const Text(
                          "Statistik Cepat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: [
                            _buildStatCard(
                              "Total Pemasukan",
                              formatter.format(stats.totalPemasukan),
                              Icons.trending_up,
                              Colors.blue,
                            ),
                            _buildStatCard(
                              "Total Pengeluaran",
                              formatter.format(stats.totalPengeluaran),
                              Icons.trending_down,
                              Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Target Section (Dipindahkan ke dalam BlocBuilder DashboardAllLoaded)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Progress Target 🎯",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: percentage / 100,
                                  minHeight: 12,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    percentage >= 100
                                        ? Colors.green
                                        : AppColors.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${percentage.toStringAsFixed(1)}%",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${formatter.format(summary.totalCollected.toInt())}/${formatter.format(summary.totalNeeded.toInt())}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildTargetDetailRow(
                                  "Total Target",
                                  summary.totalTarget.toString(),
                                  Icons.flag,
                                ),
                                _buildTargetDetailRow(
                                  "Target Aktif",
                                  summary.activeTargets.toString(),
                                  Icons.running_with_errors,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is DashboardError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 16),

              /// Chart Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Grafik Keuangan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<DashboardChartBloc, DashboardChartState>(
                        builder: (context, state) {
                          if (state is DashboardChartLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is DashboardChartLoaded) {
                            return DashboardChartWidget(
                              monthlyData: state.monthlyData,
                              kategoriData: state.kategoriData,
                            );
                          } else if (state is DashboardChartError) {
                            return Text(
                              "Gagal memuat grafik: ${state.message}",
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _performLogout(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

void _performLogout(BuildContext context) {
  // Here you would typically:
  // 1. Clear any user session or tokens
  // 2. Navigate to login page and clear navigation stack

  // Example navigation (adjust the route name to your login route)
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ), // Replace with your login page
    (Route<dynamic> route) => false,
  );
}

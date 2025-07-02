import 'dart:convert';
import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/dashboard_user_model.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/dashboard_chart_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/pengeluaran_kategori_chart_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/target/target_summary_model.dart';

class DashboardRepository {
  final ServiceHttpClient _httpClient;

  DashboardRepository(this._httpClient);

  Future<DashboardUserResponse> getUserInfo() async {
    final response = await _httpClient.get('/auth/me', authorized: true);
    print('📥 Status code: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return DashboardUserResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<List<MonthlyChartData>> getMonthlyChartData() async {
    final response = await _httpClient.get(
      '/dashboard?range=12month',
      authorized: true,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list =
          (data['data']['history'] as List)
              .map((e) => MonthlyChartData.fromJson(e))
              .toList();

      print(
        '📊 monthlyData: ${list.map((e) => '${e.period}: pemasukan=${e.pemasukan}, pengeluaran=${e.pengeluaran}').toList()}',
      );
      return list;
    } else {
      throw Exception('Gagal mengambil chart data');
    }
  }

  Future<List<PengeluaranKategoriChartModel>> getPengeluaranKategoriChart(
    int month,
    int year,
  ) async {
    final response = await _httpClient.get(
      '/pengeluaran/monthly-category-summary?month=$month&year=$year',
      authorized: true,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list =
          (data['data'] as List)
              .map((e) => PengeluaranKategoriChartModel.fromJson(e))
              .toList();

      print(
        '🍕 kategoriData: ${list.map((e) => '${e.categoryName}: ${e.totalAmount}').toList()}',
      );
      return list;
    } else {
      throw Exception('Gagal mengambil chart pengeluaran per kategori');
    }
  }

  Future<List<MonthlyChartData>> getMonthlyChartDataWithRange(
    String range,
  ) async {
    final response = await _httpClient.get(
      '/dashboard?range=$range',
      authorized: true,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data']['history'] as List)
          .map((e) => MonthlyChartData.fromJson(e))
          .toList();
    } else {
      throw Exception('Gagal mengambil chart data dengan range $range');
    }
  }

  Future<TargetSummaryModel> getTargetSummary() async {
    final response = await _httpClient.get('/target/summary', authorized: true);
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return TargetSummaryModel.fromJson(jsonBody);
    } else {
      throw Exception('Gagal mengambil ringkasan target');
    }
  }
}

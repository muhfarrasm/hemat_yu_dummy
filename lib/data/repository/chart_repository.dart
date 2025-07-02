// import 'dart:convert';

// import 'package:hematyu_app_dummy_fix/data/model/response/chart/ringkasan_katpeng_pie_response.dart';
// import 'package:hematyu_app_dummy_fix/data/model/response/chart/harian_katpeng_line_response.dart';
// import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

// class ChartRepository {
//   final ServiceHttpClient httpClient;

//   ChartRepository({required this.httpClient});

//   Future<RingkasanKatPengPieResponse> getRingkasanKatPengPie({
//     required String token,
//     required int month,
//     required int year,
//   }) async {
//     final response = await httpClient.get(
//       '/pengeluaran/monthly-category-summary?month=$month&year=$year',
//       authorized: true,
//     );
//     return RingkasanKatPengPieResponse.fromJson(response.body);
//   }

//   Future<HarianKatPengLineResponse> getHarianKatPengLine({
//     required String token,
//     required int kategoriId,
//     required int month,
//     required int year,
//   }) async {
//     final response = await httpClient.get(
//       '/kategori-pengeluaran/$kategoriId/daily-stats?month=$month&year=$year',
//       authorized: true,
//     );
//     return HarianKatPengLineResponse.fromJson(response.body);
//   }
// }

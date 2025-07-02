import 'dart:convert';
import 'package:hematyu_app_dummy_fix/data/model/request/transaksi/add_pemasukan_request.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/transaksi/add_pengeluaran_request.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/transaksi/pemasukan_response.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/transaksi/pengeluaran_response.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class TransaksiRepository {
  final ServiceHttpClient _httpClient;

  TransaksiRepository(this._httpClient);

  Future<PemasukanResponse> addPemasukan(AddPemasukanRequest request) async {
    final response = await _httpClient.post(
      '/pemasukan',
      request.toJson(),
      authorized: true,
    );

    if (response.statusCode == 200) {
      return PemasukanResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambahkan pemasukan');
    }
  }

  Future<PengeluaranResponse> addPengeluaran(AddPengeluaranRequest request) async {
    final response = await _httpClient.post(
      '/pengeluaran',
      request.toJson(),
      authorized: true,
    );

    if (response.statusCode == 200) {
      return PengeluaranResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambahkan pengeluaran');
    }
  }
}

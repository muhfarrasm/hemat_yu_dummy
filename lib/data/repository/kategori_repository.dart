import 'dart:convert';
import 'package:hematyu_app_dummy_fix/data/model/response/kategori/kategori_response.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class KategoriRepository {
  final ServiceHttpClient _client;

  KategoriRepository(this._client);

  Future<List<KategoriResponse>> getKategoriPemasukan() async {
    final response = await _client.get('/kategori-pemasukan', authorized: true);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return (data as List).map((e) => KategoriResponse.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil kategori pemasukan');
    }
  }

  Future<List<KategoriResponse>> getKategoriPengeluaran() async {
    final response = await _client.get('/kategori-pengeluaran', authorized: true);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return (data as List).map((e) => KategoriResponse.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil kategori pengeluaran');
    }
  }
}

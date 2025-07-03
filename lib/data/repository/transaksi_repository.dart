import 'dart:convert';
import 'dart:io';
import 'package:hematyu_app_dummy_fix/data/model/request/transaksi/add_pemasukan_request.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/transaksi/add_pengeluaran_request.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/transaksi/pemasukan_response.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/transaksi/pengeluaran_response.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class TransaksiRepository {
  final ServiceHttpClient _httpClient;

  TransaksiRepository(this._httpClient);

  Future<PemasukanResponse> addPemasukan(AddPemasukanRequest request) async {
    final fields = {
      'jumlah': request.jumlah,
      'tanggal': request.tanggal,
      'kategori_id': request.kategoriId.toString(),
      if (request.deskripsi != null) 'deskripsi': request.deskripsi!,
      if (request.lokasi != null) 'lokasi': request.lokasi!,
    };

    final file = request.buktiPath != null ? File(request.buktiPath!) : null;

    print('📤 Kirim Pemasukan:');
    print('   ➕ Fields: $fields');
    print('   🖼️ File: ${file?.path}');

    final response = await _httpClient.postMultipart(
      '/pemasukan',
      fields: fields,
      file: file,
      authorized: true,
    );

    final body = await response.stream.bytesToString();
    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: $body');

    if (response.statusCode == 201) {
      return PemasukanResponse.fromJson(jsonDecode(body));
    } else {
      throw Exception(jsonDecode(body)['message'] ?? 'Gagal menambahkan pemasukan');
    }
  }

  Future<PengeluaranResponse> addPengeluaran(AddPengeluaranRequest request) async {
    final fields = {
      'jumlah': request.jumlah,
      'tanggal': request.tanggal,
      'kategori_id': request.kategoriId.toString(),
      if (request.deskripsi != null) 'deskripsi': request.deskripsi!,
      if (request.lokasi != null) 'lokasi': request.lokasi!,
    };

    final file = request.buktiPath != null ? File(request.buktiPath!) : null;

    print('📤 Kirim Pengeluaran:');
    print('   ➖ Fields: $fields');
    print('   🖼️ File: ${file?.path}');

    final response = await _httpClient.postMultipart(
      '/pengeluaran',
      fields: fields,
      file: file,
      authorized: true,
    );

    final body = await response.stream.bytesToString();
    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: $body');

    if (response.statusCode == 201) {
      return PengeluaranResponse.fromJson(jsonDecode(body));
    } else {
      throw Exception(jsonDecode(body)['message'] ?? 'Gagal menambahkan pengeluaran');
    }
  }
}

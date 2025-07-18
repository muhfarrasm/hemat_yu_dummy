import 'dart:convert';
import 'package:hematyu_app_dummy_fix/data/model/response/kategori/kategori_response.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
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

  Future<List<KategoriResponse>> getKategoriTarget() async {
  final response = await _client.get('/kategori-target', authorized: true);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'];
    return (data as List).map((e) => KategoriResponse.fromJson(e)).toList();
  } else {
    throw Exception('Gagal mengambil kategori target');
  }
}
  // Untuk ambil data yang ada dalam kategori tersebut pemasukan/pengeluaran/targets
// Future<KategoriResponse> getDetailKategori({
//   required JenisKategori type,
//   required int id,
// }) async {
//   final response = await _client.get('${_endpoint(type)}/$id', authorized: true);
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);

    
//     final kategoriJson = switch (type) {
//       JenisKategori.pengeluaran => data['data']['kategori'],
//       JenisKategori.target => data['data']['kategori'],
//       JenisKategori.pemasukan => data['data'], 
//     };

//     return KategoriResponse.fromJson(kategoriJson);
//   } else {
//     throw Exception('Gagal mengambil detail kategori');
//   }
// }

Future<KategoriResponse> getDetailKategori({
  required JenisKategori type,
  required int id,
}) async {
  final response =
      await _client.get('${_endpoint(type)}/$id', authorized: true);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (type == JenisKategori.pengeluaran || type == JenisKategori.target) {
      final kategoriJson = data['data']['kategori'];
      final statistikJson = data['data']['statistik'];
      return KategoriResponse.fromJson(kategoriJson, statistikJson: statistikJson);
    } else {
      final kategoriJson = data['data'];
      return KategoriResponse.fromJson(kategoriJson);
    }
  } else {
    throw Exception('Gagal mengambil detail kategori');
  }
}


Future<void> createKategori({
  required JenisKategori type,
  required String nama,
  String? deskripsi,
  double? anggaran,
}) async {
  final body = {
    'nama_kategori': nama,
    if (deskripsi != null) 'deskripsi': deskripsi,
    if (anggaran != null && type == JenisKategori.pengeluaran) 'anggaran': anggaran.toString()
  };

  final response = await _client.post(_endpoint(type), body, authorized: true);
  if (response.statusCode != 201) throw Exception('Gagal menambahkan kategori');
}

Future<void> updateKategori({
  required JenisKategori type,
  required int id,
  required String nama,
  String? deskripsi,
  double? anggaran,
}) async {
  final body = {
    'nama_kategori': nama,
    if (deskripsi != null) 'deskripsi': deskripsi,
    if (anggaran != null && type == JenisKategori.pengeluaran) 'anggaran': anggaran.toString()
  };

  final response = await _client.put('${_endpoint(type)}/$id', body, authorized: true);
  if (response.statusCode != 200) throw Exception('Gagal memperbarui kategori');
}

Future<void> deleteKategori({
  required JenisKategori type,
  required int id,
}) async {
  final response = await _client.delete('${_endpoint(type)}/$id', authorized: true);

  if (response.statusCode == 200) return;

  final body = jsonDecode(response.body);
  if (response.statusCode == 400 || response.statusCode == 422) {
    final message = body['message'] ?? 'Kategori sedang digunakan';
    throw Exception(message);
  }

  throw Exception('Gagal menghapus kategori');
}




String _endpoint(JenisKategori type) {
  switch (type) {
    case JenisKategori.pemasukan:
      return '/kategori-pemasukan';
    case JenisKategori.pengeluaran:
      return '/kategori-pengeluaran';
    case JenisKategori.target:
      return '/kategori-target';
  }
}

}






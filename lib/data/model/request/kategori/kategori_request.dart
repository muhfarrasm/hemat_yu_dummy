import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';

class KategoriRequest {
  final String namaKategori;
  final String? deskripsi;
  final double? anggaran;

  KategoriRequest({
    required this.namaKategori,
    this.deskripsi,
    this.anggaran,
  });

  Map<String, dynamic> toJson(JenisKategori type) {
  final Map<String, dynamic> data = {
    'nama_kategori': namaKategori,
    'deskripsi': deskripsi,
  };

  if (type == JenisKategori.pengeluaran && anggaran != null) {
    data['anggaran'] = anggaran;
  }

  return data;
}

}

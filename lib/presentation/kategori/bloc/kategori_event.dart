
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';

abstract class KategoriEvent {}

class FetchKategori extends KategoriEvent {
  final JenisKategori type;

  FetchKategori(this.type);
}


class AddKategori extends KategoriEvent {
  final JenisKategori type;
  final String nama;
  final String? deskripsi;
  final double? anggaran;
  AddKategori({required this.type, required this.nama, this.deskripsi, this.anggaran});
}

class UpdateKategori extends KategoriEvent {
  final JenisKategori type;
  final int id;
  final String nama;
  final String? deskripsi;
  final double? anggaran;

  UpdateKategori({
    required this.type,
    required this.id,
    required this.nama,
    this.deskripsi,
    this.anggaran,
  });
}


class DeleteKategori extends KategoriEvent {
  final JenisKategori type;
  final int id;
  DeleteKategori({required this.type, required this.id});
}

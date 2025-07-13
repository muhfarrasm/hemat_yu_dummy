// class KategoriResponse {
//   final int id;
//   final String namaKategori;
//   final String? deskripsi;
//   //Pengeluaran
//   final double? anggaran; // hanya pengeluaran yang punya
//   final double pengeluaranSumJumlah;
//   //Target
//   final int? jumlahTarget; // hanya target
//   final double? totalTargetDana; // hanya target
//   final double? totalTerkumpul; // hanya target
//   final double? persentasePencapaian; // hanya target

//   final int userId;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   final List<Map<String, dynamic>>? targets;
//   final List<Map<String, dynamic>>? pengeluaran;
//   final List<Map<String, dynamic>>? pemasukan;

//   KategoriResponse({
//     required this.id,
//     required this.namaKategori,
//     this.deskripsi,
//     this.anggaran = 0.0,
//     this.pengeluaranSumJumlah = 0.0,

//     required this.userId,
//     this.jumlahTarget,
//     this.totalTargetDana = 0.0,
//     this.totalTerkumpul = 0.0,
//     this.persentasePencapaian = 0.0,
//     required this.createdAt,
//     required this.updatedAt,

//     this.targets,
//     this.pengeluaran,
//     this.pemasukan,
//   });

//   factory KategoriResponse.fromJson(Map<String, dynamic> json) {
//     double parseDoubleOrZero(dynamic value) {
//       if (value == null) return 0.0;
//       final parsed = double.tryParse(value.toString());
//       return parsed ?? 0.0;
//     }
//     return KategoriResponse(
//       id: json['id'],
//       namaKategori: json['nama_kategori'],
//       deskripsi: json['deskripsi'],
//       anggaran: parseDoubleOrZero(json['anggaran']),
//       pengeluaranSumJumlah: parseDoubleOrZero(json['pengeluaran_sum_jumlah']),
//       userId: json['user_id'],
//       jumlahTarget: json['jumlah_target'],
//        totalTargetDana: parseDoubleOrZero(json['total_target_dana']),
//       totalTerkumpul: parseDoubleOrZero(json['total_terkumpul']),
//       persentasePencapaian: parseDoubleOrZero(json['persentase_pencapaian']),
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),

//       targets:
//           json['targets'] != null
//               ? List<Map<String, dynamic>>.from(json['targets'])
//               : null,
//       pengeluaran:
//           json['pengeluaran'] != null
//               ? List<Map<String, dynamic>>.from(json['pengeluaran'])
//               : null,
//       pemasukan:
//           json['pemasukan'] != null
//               ? List<Map<String, dynamic>>.from(json['pemasukan'])
//               : null,
//     );
//   }
// }


class KategoriResponse {
  final int id;
  final String namaKategori;
  final String? deskripsi;

  final double? anggaran; // pengeluaran
  final double pengeluaranSumJumlah; // list pengeluaran

  final double? totalPengeluaran; // statistik pengeluaran
  final double? sisaAnggaran; // statistik pengeluaran

  final int? jumlahTarget; // target
  final double? totalTargetDana; // target
  final double? totalTerkumpul; // target
  final double? persentasePencapaian; // target

  final DateTime createdAt;
  final DateTime updatedAt;

  final List<Map<String, dynamic>>? targets; // detail target
  final List<Map<String, dynamic>>? pengeluaran; // detail pengeluaran
  final List<Map<String, dynamic>>? pemasukan; // detail pemasukan

  KategoriResponse({
    required this.id,
    required this.namaKategori,
    this.deskripsi,
    this.anggaran = 0.0,
    this.pengeluaranSumJumlah = 0.0,
    this.totalPengeluaran,
    this.sisaAnggaran,
    this.jumlahTarget,
    this.totalTargetDana,
    this.totalTerkumpul,
    this.persentasePencapaian,
    required this.createdAt,
    required this.updatedAt,
    this.targets,
    this.pengeluaran,
    this.pemasukan,
  });

  factory KategoriResponse.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? statistikJson,
  }) {
    double parseDoubleOrZero(dynamic value) {
      if (value == null) return 0.0;
      final parsed = double.tryParse(value.toString());
      return parsed ?? 0.0;
    }

    return KategoriResponse(
      id: json['id'],
      namaKategori: json['nama_kategori'],
      deskripsi: json['deskripsi'],
      anggaran: parseDoubleOrZero(json['anggaran']),
      pengeluaranSumJumlah: parseDoubleOrZero(json['pengeluaran_sum_jumlah']),
      totalPengeluaran: statistikJson != null
          ? parseDoubleOrZero(statistikJson['total_pengeluaran'])
          : null,
      sisaAnggaran: statistikJson != null
          ? parseDoubleOrZero(statistikJson['sisa_anggaran'])
          : null,
      jumlahTarget: json['jumlah_target'],
      totalTargetDana: statistikJson != null
          ? parseDoubleOrZero(statistikJson['total_target_dana'])
          : parseDoubleOrZero(json['total_target_dana']),
      totalTerkumpul: statistikJson != null
          ? parseDoubleOrZero(statistikJson['total_terkumpul'])
          : parseDoubleOrZero(json['total_terkumpul']),
      persentasePencapaian: statistikJson != null
          ? parseDoubleOrZero(statistikJson['persentase_pencapaian'])
          : parseDoubleOrZero(json['persentase_pencapaian']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      targets: json['targets'] != null
          ? List<Map<String, dynamic>>.from(json['targets'])
          : null,
      pengeluaran: json['pengeluaran'] != null
          ? List<Map<String, dynamic>>.from(json['pengeluaran'])
          : null,
      pemasukan: json['pemasukan'] != null
          ? List<Map<String, dynamic>>.from(json['pemasukan'])
          : null,
    );
  }
}

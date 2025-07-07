class KategoriResponse {
  final int id;
  final String namaKategori;
  final String? deskripsi;
  final double? anggaran; // hanya pengeluaran yang punya
  final int userId;
  final int? jumlahTarget; // hanya target
  final double? totalTargetDana; // hanya target
  final double? totalTerkumpul; // hanya target
  final double? persentasePencapaian; // hanya target
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<Map<String, dynamic>>? targets;
  final List<Map<String, dynamic>>? pengeluaran;
  final List<Map<String, dynamic>>? pemasukan;

  KategoriResponse({
    required this.id,
    required this.namaKategori,
    this.deskripsi,
    this.anggaran,
    required this.userId,
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

  factory KategoriResponse.fromJson(Map<String, dynamic> json) {
    return KategoriResponse(
      id: json['id'],
      namaKategori: json['nama_kategori'],
      deskripsi: json['deskripsi'],
      anggaran:
          json['anggaran'] != null
              ? double.tryParse(json['anggaran'].toString())
              : null,
      userId: json['user_id'],
      jumlahTarget: json['jumlah_target'],
      totalTargetDana: json['total_target_dana'] != null ? double.tryParse(json['total_target_dana'].toString()) : null,
      totalTerkumpul: json['total_terkumpul'] != null ? double.tryParse(json['total_terkumpul'].toString()) : null,
      persentasePencapaian: json['persentase_pencapaian'] != null ? double.tryParse(json['persentase_pencapaian'].toString()) : null,
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

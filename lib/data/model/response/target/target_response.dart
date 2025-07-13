class TargetResponse {
  final int id;
  final String namaTarget;
  final double targetDana;
  final double terkumpul;
  final String targetTanggal;
  final String deskripsi;
  final String status;
  final double persentase;
  final double sisaTarget;
  final int? kategoriTargetId;
  final String? namaKategori;
  final String createdAt;
  final String updatedAt;

  TargetResponse({
    required this.id,
    required this.namaTarget,
    required this.targetDana,
    required this.terkumpul,
    required this.targetTanggal,
    required this.deskripsi,
    required this.status,
    required this.persentase,
    required this.sisaTarget,
    required this.kategoriTargetId,
    this.namaKategori,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TargetResponse.fromJson(Map<String, dynamic> json) {
    return TargetResponse(
      id: json['id'],
      namaTarget: json['nama_target'],
      targetDana: (json['target_dana'] ?? 0).toDouble(),
      terkumpul: (json['terkumpul'] ?? 0).toDouble(),
      targetTanggal: json['target_tanggal'],
      deskripsi: json['deskripsi'],
      status: json['status'],
      persentase: (json['persentase'] ?? 0).toDouble(),
      sisaTarget: (json['sisa_target'] ?? 0).toDouble(),
      kategoriTargetId: json['kategori_target_id'],
      namaKategori: json['nama_kategori'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  bool get isActive {
    final now = DateTime.now();
    return DateTime.parse(targetTanggal).isAfter(now) && terkumpul < targetDana;
  }
}

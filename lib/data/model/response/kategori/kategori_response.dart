class KategoriResponse{
  final int id;
  final String namaKategori;
  final String? deskripsi;
  final double? anggaran; // hanya pengeluaran yang punya
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  KategoriResponse({
    required this.id,
    required this.namaKategori,
    this.deskripsi,
    this.anggaran,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KategoriResponse.fromJson(Map<String, dynamic> json) {
    return KategoriResponse(
      id: json['id'],
      namaKategori: json['nama_kategori'],
      deskripsi: json['deskripsi'],
      anggaran: json['anggaran'] != null ? double.tryParse(json['anggaran'].toString()) : null,
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class AddPemasukanRequest {
  final String jumlah;
  final String tanggal;
  final int kategoriId;
  final String? deskripsi;
  final String? buktiPath; // File name (server will map it)
  final String? lokasi;

  AddPemasukanRequest({
    required this.jumlah,
    required this.tanggal,
    required this.kategoriId,
    this.deskripsi,
    this.buktiPath,
    this.lokasi,
  });

  Map<String, dynamic> toJson() {
    return {
      'jumlah': jumlah,
      'tanggal': tanggal,
      'kategori_id': kategoriId.toString(),
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (buktiPath != null) 'bukti_transaksi': buktiPath,
      if (lokasi != null) 'lokasi': lokasi,
    };
  }
}

class AddPengeluaranRequest {
  final String jumlah;
  final String tanggal;
  final int kategoriId;
  final String? deskripsi;
  final String? buktiPath;
  final String? lokasi;

  AddPengeluaranRequest({
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

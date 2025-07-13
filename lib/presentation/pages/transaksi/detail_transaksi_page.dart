import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';

class DetailTransaksiPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isPemasukan;

  const DetailTransaksiPage({
    super.key,
    required this.data,
    required this.isPemasukan,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final jumlah = double.tryParse(data['jumlah'].toString()) ?? 0;
    final tanggal = DateTime.tryParse(data['tanggal'] ?? '') ?? DateTime.now();
    final deskripsi = data['deskripsi'] ?? '-';
    final lokasi = data['lokasi'] ?? '-';
    final namaKategori = data['nama_kategori'] ?? '-';
    final buktiUrl =
        data['bukti_transaksi'] != null
            ? 'http://192.168.48.61:8000${data['bukti_transaksi']}'
            : null;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: AppColors.lightTextColor,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Kembali',
            ),
          ),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundColor.withOpacity(0.9),
              AppColors.accentColor.withOpacity(0.1),
            ],
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      isPemasukan ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isPemasukan ? Colors.green : Colors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      formatter.format(jumlah),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isPemasukan ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  _buildRow(
                    Icons.calendar_today,
                    'Tanggal',
                    DateFormat('dd MMM yyyy').format(tanggal),
                  ),
                  _buildRow(Icons.category, 'Kategori', namaKategori),
                  _buildRow(Icons.description, 'Deskripsi', deskripsi),
                  _buildRow(Icons.location_on, 'Lokasi', lokasi),
                  const SizedBox(height: 20),
                  if (buktiUrl != null && buktiUrl.toString().isNotEmpty) ...[
                    const Text(
                      'Bukti Transaksi:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        buktiUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const Text(
                              '⚠️ Gagal memuat gambar',
                              style: TextStyle(color: Colors.red),
                            ),
                      ),
                    ),
                  ] else
                    const Text('Tidak ada bukti transaksi.'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 2, child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

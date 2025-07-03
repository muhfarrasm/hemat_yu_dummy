import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            ? 'http://192.168.185.61:8000${data['bukti_transaksi']}'
            : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              ],
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
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
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    final jumlah = double.tryParse(data['jumlah'].toString()) ?? 0;
    final tanggal = DateTime.tryParse(data['tanggal'] ?? '') ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatter.format(jumlah),
              style: TextStyle(
                fontSize: 24,
                color: isPemasukan ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Tanggal: ${DateFormat('dd MMM yyyy').format(tanggal)}'),
            Text('Deskripsi: ${data['deskripsi'] ?? '-'}'),
            Text('Lokasi: ${data['lokasi'] ?? '-'}'),
            Text('Kategori ID: ${data['kategori_id'] ?? '-'}'),
            const SizedBox(height: 16),
            if (data['bukti_transaksi'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bukti Transaksi:'),
                  const SizedBox(height: 8),
                  Image.network(
                    data['bukti_transaksi'],
                    height: 200,
                    errorBuilder: (_, __, ___) => const Text('Gagal memuat gambar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

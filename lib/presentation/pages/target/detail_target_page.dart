import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailTargetPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailTargetPage({super.key, required this.data});

  String formatCurrency(dynamic value) {
    final number = double.tryParse(value.toString()) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  String formatDate(dynamic rawDate) {
    if (rawDate == null) return '-';

    try {
      final date =
          rawDate is String ? DateTime.parse(rawDate) : rawDate as DateTime;
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return rawDate.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Target')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildDetailItem('Nama Target', data['nama_target']),
            _buildDetailItem('Deskripsi', data['deskripsi']),
            _buildDetailItem(
              'Target Dana',
              formatCurrency(data['target_dana']),
            ),
            _buildDetailItem(
              'Terkumpul',
              formatCurrency(data['terkumpul'] ?? 0),
            ),
            _buildDetailItem(
              'Tanggal Target',
              formatDate(data['target_tanggal']),
            ),
            _buildDetailItem(
              'Nama Kategori Target ',
              '${data['nama_kategori']}',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? '-', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';

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
        title: const Text(
          'Detail Target',
          style: TextStyle(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.w800,
            fontSize: 22,
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
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildDetailItem(Icons.flag, 'Nama Target', data['nama_target']),
            _buildDetailItem(Icons.description, 'Deskripsi', data['deskripsi']),
            _buildDetailItem(
              Icons.monetization_on,
              'Target Dana',
              formatCurrency(data['target_dana']),
            ),
            _buildDetailItem(
              Icons.account_balance_wallet,
              'Terkumpul',
              formatCurrency(data['terkumpul'] ?? 0),
            ),
            _buildDetailItem(
              Icons.date_range,
              'Tanggal Target',
              formatDate(data['target_tanggal']),
            ),
            _buildDetailItem(
              Icons.category,
              'Nama Kategori Target',
              '${data['nama_kategori']}',
            ),
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
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryColor), // ✅ Tambah icon di sini
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? '-',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

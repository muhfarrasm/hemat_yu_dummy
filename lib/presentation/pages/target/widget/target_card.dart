import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/target/target_response.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/target/detail_target_page.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';

class TargetCard extends StatelessWidget {
  final TargetResponse target;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TargetCard({
    super.key,
    required this.target,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = target.isActive ? Colors.green : Colors.red;
    final persen = target.persentase.clamp(0, 100);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4, // ✅ Tambah shadow biar melayang
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white, // ✅ Pastikan background putih kontras
      shadowColor: Colors.black54, // ✅ Shadow lebih gelap biar tegas
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailTargetPage(data: {
                'nama_target': target.namaTarget,
                'deskripsi': target.deskripsi,
                'target_dana': target.targetDana,
                'terkumpul': target.terkumpul,
                'target_tanggal': target.targetTanggal,
                'nama_kategori': target.namaKategori,
              }),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul + status bulat
              Row(
                children: [
                  Expanded(
                    child: Text(
                      target.namaTarget,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, 
                      ),
                    ),
                  ),
                  Icon(Icons.circle, color: statusColor, size: 12),
                ],
              ),
              const SizedBox(height: 8),
              // Dana info
              Text(
                "Rp${target.terkumpul.toStringAsFixed(0)} / Rp${target.targetDana.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: persen / 100,
                  backgroundColor: Colors.grey[300],
                  color: AppColors.primaryColor,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              // Persen & tanggal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${persen.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Target: ${target.targetTanggal}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Tombol aksi
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

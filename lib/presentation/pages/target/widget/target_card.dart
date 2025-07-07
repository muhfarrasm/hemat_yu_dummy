import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/target/target_response.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/target/detail_target_page.dart';

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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.circle, color: statusColor, size: 14),
        title: Text(target.namaTarget),
        subtitle: Text(
          "${(target.persentase * 100).toStringAsFixed(0)}%",
          // "Rp${target.terkumpul.toStringAsFixed(0)} dari Rp${target.targetDana.toStringAsFixed(0)}",
        ),
       trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}

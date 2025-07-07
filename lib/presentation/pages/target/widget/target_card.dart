import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/target/target_response.dart';

class TargetCard extends StatelessWidget {
  final TargetResponse target;

  const TargetCard({super.key, required this.target});

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
          "Rp${target.terkumpul.toStringAsFixed(0)} dari Rp${target.targetDana.toStringAsFixed(0)}",
        ),
        trailing: Text("${(target.persentase * 100).toStringAsFixed(0)}%"),
        onTap: () {
          // Detail / edit / delete action
        },
      ),
    );
  }
}

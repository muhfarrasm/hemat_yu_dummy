import 'package:flutter/material.dart';

class DashboardSummary extends StatelessWidget {
  final int pemasukan;

  const DashboardSummary({
    super.key,
    required this.pemasukan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pemasukan Bulan Ini',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Rp $pemasukan',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

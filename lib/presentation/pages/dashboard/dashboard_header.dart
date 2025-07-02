import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String username;
  final int saldo;

  const DashboardHeader({
    super.key,
    required this.username,
    required this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, $username',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Saldo Saat Ini: Rp $saldo',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

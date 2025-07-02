import 'package:flutter/material.dart';

class TransaksiPage extends StatelessWidget {
  final VoidCallback onBackToDashboard;

  const TransaksiPage({super.key, required this.onBackToDashboard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToDashboard, // custom back!
        ),
      ),
      body: Center(
        // child: ElevatedButton(
        //   onPressed: onBackToDashboard,
        //   child: const Text('Back to Dashboard'),
        // ),
      ),
    );
  }
}

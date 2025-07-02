import 'package:flutter/material.dart';

class KategoriPage extends StatelessWidget {
  final VoidCallback onBackToDashboard;

  const KategoriPage({super.key, required this.onBackToDashboard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToDashboard, // custom back!
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: onBackToDashboard,
          child: const Text('Back to Dashboard'),
        ),
      ),
    );
  }
}

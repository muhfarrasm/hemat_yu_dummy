import 'package:flutter/material.dart';

class TargetPage extends StatelessWidget {
  final VoidCallback onBackToDashboard;

  const TargetPage({super.key, required this.onBackToDashboard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Page'),
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

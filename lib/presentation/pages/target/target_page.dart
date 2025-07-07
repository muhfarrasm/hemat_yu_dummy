import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/target/target_response.dart';
import 'package:hematyu_app_dummy_fix/data/repository/target_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/target/widget/target_card.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class TargetPage extends StatefulWidget {
  final VoidCallback onBackToDashboard;

  const TargetPage({super.key, required this.onBackToDashboard});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  late Future<List<TargetResponse>> _futureTargets;

  @override
  void initState() {
    super.initState();
    _futureTargets = TargetRepository(ServiceHttpClient()).getTargets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Target'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackToDashboard,
        ),
      ),
      body: FutureBuilder<List<TargetResponse>>(
        future: _futureTargets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}'));
          }

          final targets = snapshot.data!;
          if (targets.isEmpty) {
            return const Center(child: Text('Belum ada target.'));
          }

          return ListView(
            children: targets.map((t) => TargetCard(target: t)).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Arahkan ke form tambah target nanti
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

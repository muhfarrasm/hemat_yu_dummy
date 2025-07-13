import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/target/target_response.dart';
import 'package:hematyu_app_dummy_fix/data/repository/target_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/target/widget/target_card.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/target/form_target_page.dart'; // enum JenisKategori.target
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';

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

  void _fetchTargets() {
    setState(() {
      _futureTargets = TargetRepository(ServiceHttpClient()).getTargets();
    });
  }

  Future<void> _deleteTarget(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Hapus Target'),
            content: const Text(
              'Apakah kamu yakin ingin menghapus target ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      final response = await TargetRepository(
        ServiceHttpClient(),
      ).deleteTarget(id);
      if (response) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
        _fetchTargets();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal menghapus target')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // ✅ Transparan untuk gradient
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
              onPressed: widget.onBackToDashboard,
              tooltip: 'Kembali',
            ),
          ),
        ),
         title: Row(
          children: [
            const Text(
              'Daftar Target',
              style: TextStyle(
                color: AppColors.lightTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
              const Spacer(),
          
            IconButton(
              icon: const Icon(
                Icons.add,
                color: AppColors.lightTextColor,
                size: 24,
              ),
              tooltip: 'Tambah Target',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FormTargetPage()),
                );
                if (result == true) {
                  _fetchTargets();
                }
              },
            ),
            const SizedBox(width: 2),
          ],
        ),
      
      ),
       backgroundColor: AppColors.backgroundColor,
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
          return RefreshIndicator(
            onRefresh: () async {
              _fetchTargets();
            },

          child: ListView(
            children:
                targets.map((target) {
                  return TargetCard(
                    target: target,
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => FormTargetPage(
                                isEdit: true,
                                initialData: {
                                  'id': target.id,
                                  'nama_target': target.namaTarget,
                                  'deskripsi': target.deskripsi,
                                  'target_dana': target.targetDana,
                                  'target_tanggal':
                                      target.targetTanggal,
                                  'nama_kategori':
                                      null, // sesuaikan jika ada
                                }, // Pastikan TargetResponse punya toJson
                              ),
                        ),
                      );
                      if (result == true) _fetchTargets();
                    },
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text("Konfirmasi"),
                              content: const Text(
                                "Yakin ingin menghapus target ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                      );

                      if (confirmed == true) {
                        final success = await TargetRepository(
                          ServiceHttpClient(),
                        ).deleteTarget(target.id);
                        if (success) {
                          _fetchTargets();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Target berhasil dihapus'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gagal menghapus target'),
                            ),
                          );
                        }
                      }
                    },
                  );
                }).toList(),
          ),
          );
        },
      ),
    );
  }
}

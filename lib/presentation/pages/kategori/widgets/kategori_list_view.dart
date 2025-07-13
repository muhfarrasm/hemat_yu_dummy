import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/kategori_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_state.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/kategori/detail_kategori_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/kategori/form_kategori_page.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class KategoriListView extends StatelessWidget {
  final JenisKategori jenis;

  const KategoriListView({super.key, required this.jenis});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KategoriBloc, KategoriState>(
      builder: (context, state) {
        if (state is KategoriLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is KategoriLoaded) {
          final list = state.kategoriList;
          if (list.isEmpty) {
            return const Center(child: Text('Belum ada kategori.'));
          }
          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemBuilder: (_, index) {
              final kategori = list[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(kategori.namaKategori),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (jenis == JenisKategori.pengeluaran)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Anggaran: Rp${kategori.anggaran?.toStringAsFixed(0)}",
                            ),
                            Text(
                              "Total Pengeluaran: Rp${kategori.pengeluaranSumJumlah.toStringAsFixed(0)}",
                            ),
                            Text(
                              "Sisa: Rp${(kategori.anggaran! - kategori.pengeluaranSumJumlah).toStringAsFixed(0)}",
                            ),
                          ],
                        ),
                      // target
                      if (jenis == JenisKategori.target)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rp${kategori.totalTerkumpul?.toStringAsFixed(0) ?? '0'} / Rp${kategori.totalTargetDana?.toStringAsFixed(0) ?? '0'}",
                            ),
                            const SizedBox(height: 4), // jarak kecil biar rapi
                            LinearProgressIndicator(
                              value: ((kategori.persentasePencapaian ?? 0) /
                                      100)
                                  .clamp(0.0, 1.0),
                              minHeight: 6,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${kategori.persentasePencapaian?.toStringAsFixed(1) ?? '0'}%", // ✅ TAMPIL PERSENAN
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => FormKategoriPage(
                                    jenis: jenis,
                                    isEdit: true,
                                    initialData: kategori,
                                  ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              context.read<KategoriBloc>().add(
                                FetchKategori(jenis),
                              );
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8), // nanti diisi tombol delete

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Hapus Kategori'),
                                  content: const Text(
                                    'Yakin ingin menghapus kategori ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm != true) return;

                          try {
                            await KategoriRepository(
                              ServiceHttpClient(),
                            ).deleteKategori(type: jenis, id: kategori.id);

                            context.read<KategoriBloc>().add(
                              FetchKategori(jenis),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Kategori berhasil dihapus'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('❌ ${e.toString()}')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetailKategoriPage(
                              jenis: jenis,
                              id: kategori.id, // <- kirim ID saja
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else if (state is KategoriError) {
          return Center(child: Text('❌ ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

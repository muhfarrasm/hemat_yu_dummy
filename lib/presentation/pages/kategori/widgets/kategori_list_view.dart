import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_state.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/kategori/detail_kategori_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/kategori/form_kategori_page.dart';

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
                      if (kategori.deskripsi != null &&
                          kategori.deskripsi!.isNotEmpty)
                        Text(kategori.deskripsi!),
                      if (jenis == JenisKategori.pengeluaran &&
                          kategori.anggaran != null)
                        Text(
                          "Anggaran: Rp${kategori.anggaran?.toStringAsFixed(0)}",
                        ),
                      if (jenis == JenisKategori.target)
                        Text(
                          "Terkumpul: Rp${kategori.totalTerkumpul?.toStringAsFixed(0) ?? '0'} / "
                          "Target: Rp${kategori.totalTargetDana?.toStringAsFixed(0) ?? '0'}",
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

                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
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

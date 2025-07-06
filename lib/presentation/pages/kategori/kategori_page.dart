import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/kategori_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_state.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/kategori/form_kategori_page.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class KategoriPage extends StatefulWidget {
  final VoidCallback onBackToDashboard;

  const KategoriPage({super.key, required this.onBackToDashboard});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final KategoriBloc _bloc = KategoriBloc(
    KategoriRepository(ServiceHttpClient()),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _bloc.add(FetchKategori(JenisKategori.pemasukan));

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      switch (_tabController.index) {
        case 0:
          _bloc.add(FetchKategori(JenisKategori.pemasukan));
          break;
        case 1:
          _bloc.add(FetchKategori(JenisKategori.pengeluaran));
          break;
        case 2:
          _bloc.add(FetchKategori(JenisKategori.target));
          break;
      }
    });
  }

  JenisKategori get currentType {
    switch (_tabController.index) {
      case 0:
        return JenisKategori.pemasukan;
      case 1:
        return JenisKategori.pengeluaran;
      case 2:
        return JenisKategori.target;
      default:
        return JenisKategori.pemasukan;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Kategori'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBackToDashboard,
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Pemasukan'),
              Tab(text: 'Pengeluaran'),
              Tab(text: 'Target'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            KategoriListView(jenis: JenisKategori.pemasukan),
            KategoriListView(jenis: JenisKategori.pengeluaran),
            KategoriListView(jenis: JenisKategori.target),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FormKategoriPage(jenis: currentType),
              ),
            );
            if (result == true) {
              context.read<KategoriBloc>().add(FetchKategori(currentType));
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

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
                    ],
                  ),
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

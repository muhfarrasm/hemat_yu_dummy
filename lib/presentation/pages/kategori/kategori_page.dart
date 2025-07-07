import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/kategori_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/kategori/form_kategori_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/kategori/widgets/kategori_list_view.dart';
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
           elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
            onPressed: widget.onBackToDashboard,
          ),
          title: const Text('Manajemen Kategori',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
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



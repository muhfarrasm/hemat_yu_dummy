import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';
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
          backgroundColor: Colors.transparent, // Set to transparent
          flexibleSpace: Container(
            decoration: BoxDecoration(
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
              backgroundColor:
                  AppColors.lightTextColor, // White circle for contrast
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.primaryColor,
                ), // Icon color to primary
                onPressed: widget.onBackToDashboard,
                tooltip: 'Kembali ke Dashboard', // Add tooltip
              ),
            ),
          ),
          title: const Text(
            'Manajemen Kategori',
            style: TextStyle(
              color:
                  AppColors
                      .lightTextColor, // Changed to lightTextColor for contrast
              fontWeight: FontWeight.w800, // Even bolder title
              fontSize: 24, // Larger title
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
              kToolbarHeight + 30,
            ), // Slightly taller tab bar
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // Padding for tab bar
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardColor, // White background for tabs
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Rounded corners for tab bar container
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyColor.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Subtle shadow
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 47, 131, 26), // Solid color for selected tab
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Rounded indicator
                  ),
                  labelColor:
                      AppColors.lightTextColor, // White text for selected tab
                  unselectedLabelColor:
                      AppColors.greyColor, // Grey text for unselected
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700, // Very bold selected tab text
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  indicatorSize:
                      TabBarIndicatorSize.tab, // Indicator covers the whole tab
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward_rounded, size: 18),
                          SizedBox(width: 2), // Adjusted width
                          Expanded(
                            // Added Expanded to prevent overflow
                            child: Text(
                              'Pemasukan',
                              overflow: TextOverflow.ellipsis, // Added ellipsis
                              maxLines: 1, // Ensure single line
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward_rounded, size: 18),
                          SizedBox(width: 2), // Adjusted width
                          Expanded(
                            // Added Expanded to prevent overflow
                            child: Text(
                              'Pengeluaran',
                              overflow: TextOverflow.ellipsis, // Added ellipsis
                              maxLines: 1, // Ensure single line
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.track_changes_rounded, size: 18),
                          SizedBox(width: 2), // Adjusted width
                          Expanded(
                            // Added Expanded to prevent overflow
                            child: Text(
                              'Target',
                              overflow: TextOverflow.ellipsis, // Added ellipsis
                              maxLines: 1, // Ensure single line
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
                
              ),
              
            ),
          ),
        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundColor.withOpacity(0.9),
                AppColors.accentColor.withOpacity(0.1),
              ],
            ), // Background color for the body
          ),
          

          child: TabBarView(
            controller: _tabController,
            children: const [
              KategoriListView(jenis: JenisKategori.pemasukan),
              KategoriListView(jenis: JenisKategori.pengeluaran),
              KategoriListView(jenis: JenisKategori.target),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FormKategoriPage(jenis: currentType),
              ),
            );
            if (result == true) {
              // Use Future.delayed to allow Navigator.pop to complete animation
              Future.delayed(const Duration(milliseconds: 100), () {
                context.read<KategoriBloc>().add(FetchKategori(currentType));
              });
            }
          },
          label: const Text(
            'Tambah Kategori',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          icon: const Icon(Icons.add_rounded),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.lightTextColor,
          elevation: 8, // More pronounced shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Pill shape for FAB
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat, // Center the FAB
      ),
    );
  }
}

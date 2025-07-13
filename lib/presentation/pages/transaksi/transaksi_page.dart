import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/transaksi_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/camera/bloc/camera_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/add_transaksi_page%20.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart'; 
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/widget/transaksi_list_view.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_bloc.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class TransaksiPage extends StatelessWidget {
  final VoidCallback onBackToDashboard;

  const TransaksiPage({super.key, required this.onBackToDashboard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // ✅ No shadow
        backgroundColor: Colors.transparent, // ✅ Transparent AppBar
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
          padding: const EdgeInsets.only(left: 16.0), // ✅ Sama seperti kategori
          child: CircleAvatar(
            backgroundColor: AppColors.lightTextColor,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: onBackToDashboard,
              tooltip: 'Kembali',
            ),
          ),
        ),
        title: const Text(
          'Transaksi',
          style: TextStyle(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        actions: [
           IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: AppColors.lightTextColor, 
            ),
            tooltip: 'Tambah Transaksi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => TransaksiBloc(
                          TransaksiRepository(ServiceHttpClient()),
                        ),
                      ),
                      BlocProvider(create: (_) => CameraBloc()),
                    ],
                    child: const AddTransaksiPage(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Semua Pemasukan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TransaksiListView(endpoint: '/pemasukan', isPemasukan: true),
          SizedBox(height: 16),
          Text(
            'Semua Pengeluaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TransaksiListView(endpoint: '/pengeluaran', isPemasukan: false),
        ],
      ),
    );
  }
}

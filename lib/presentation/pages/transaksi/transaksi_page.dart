import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/transaksi_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/add_transaksi_page%20.dart';

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
        title: const Text('Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToDashboard,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => TransaksiBloc(
                      TransaksiRepository(ServiceHttpClient()),
                    ),
                    child: const AddTransaksiPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Semua Pemasukan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TransaksiListView(
            endpoint: '/pemasukan',
            isPemasukan: true,
          ),
          SizedBox(height: 16),
          Text(
            'Semua Pengeluaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TransaksiListView(
            endpoint: '/pengeluaran',
            isPemasukan: false,
          ),
        ],
      ),
    );
  }
}

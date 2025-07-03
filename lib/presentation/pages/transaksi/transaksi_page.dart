import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/transaksi_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/add_transaksi_page%20.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_bloc.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:intl/intl.dart';

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
                  builder:
                      (_) => BlocProvider(
                        create:
                            (_) => TransaksiBloc(
                              TransaksiRepository(ServiceHttpClient()),
                            ),
                        child: AddTransaksiPage(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '3 Pemasukan Terakhir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _TransaksiListView(
                endpoint: '/pemasukan?limit=3',
                isPemasukan: true,
              ),
              SizedBox(height: 16),
              Text(
                '3 Pengeluaran Terakhir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _TransaksiListView(
                endpoint: '/pengeluaran?limit=3',
                isPemasukan: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransaksiListView extends StatefulWidget {
  final String endpoint;
  final bool isPemasukan;

  const _TransaksiListView({required this.endpoint, required this.isPemasukan});

  @override
  State<_TransaksiListView> createState() => _TransaksiListViewState();
}

class _TransaksiListViewState extends State<_TransaksiListView> {
  final ServiceHttpClient _httpClient = ServiceHttpClient();
  final formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  List<dynamic> data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final response = await _httpClient.get(widget.endpoint, authorized: true);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          data = json['data'];
          loading = false;
        });
      } else {
        throw Exception("Gagal mengambil data");
      }
    } catch (e) {
      print('❌ Error loading transaksi: $e');
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (data.isEmpty) return const Text('Tidak ada data');

    return Column(
      children:
          data.map((item) {
            final jumlah = double.tryParse(item['jumlah'].toString()) ?? 0;
            final tanggal =
                DateTime.tryParse(item['tanggal'] ?? '') ?? DateTime.now();
            final lokasi = item['lokasi'] ?? '-';

            return Card(
              child: ListTile(
                title: Text(
                  formatter.format(jumlah),
                  style: TextStyle(
                    color: widget.isPemasukan ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Tanggal: ${DateFormat('dd MMM yyyy').format(tanggal)}\nLokasi: $lokasi',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          }).toList(),
    );
  }
}

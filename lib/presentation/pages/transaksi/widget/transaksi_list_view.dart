import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/transaksi_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/camera/bloc/camera_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/add_transaksi_page%20.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/detail_transaksi_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_bloc.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:intl/intl.dart';

class TransaksiListView extends StatefulWidget {
  final String endpoint;
  final bool isPemasukan;

  const TransaksiListView({
    super.key,
    required this.endpoint,
    required this.isPemasukan,
  });

  @override
  State<TransaksiListView> createState() => _TransaksiListViewState();
}

class _TransaksiListViewState extends State<TransaksiListView> {
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
        if (!mounted) return;
        setState(() {
          data = json['data'];
          loading = false;
        });
      } else {
        throw Exception("Gagal mengambil data");
      }
    } catch (e) {
      print('❌ Error loading transaksi: $e');
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  void _showDetail(dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => DetailTransaksiPage(
              data: item,
              isPemasukan: widget.isPemasukan,
            ),
      ),
    ).then((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  void _handleEdit(dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create:
                      (_) => TransaksiBloc(
                        TransaksiRepository(ServiceHttpClient()),
                      ),
                ),
                BlocProvider(
                  create: (_) => CameraBloc(), // ⬅️ Tambahkan ini
                ),
              ],
              child: AddTransaksiPage(
                isEdit: true,
                isPemasukan: widget.isPemasukan,
                transaksiId: item['id'],
                initialData: item,
              ),
            ),
      ),
    ).then((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  Future<void> _handleDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Yakin ingin menghapus transaksi ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _httpClient.delete(
          widget.isPemasukan ? '/pemasukan/$id' : '/pengeluaran/$id',
          authorized: true,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menghapus transaksi')),
        );
        _loadData();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (data.isEmpty) return const Text('Tidak ada data');

    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        final item = data[index];
        final jumlah = double.tryParse(item['jumlah'].toString()) ?? 0;
        final tanggal =
            DateTime.tryParse(item['tanggal'] ?? '') ?? DateTime.now();
        final lokasi = item['lokasi'] ?? '-';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Info bagian kiri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatter.format(jumlah),
                        style: TextStyle(
                          color: widget.isPemasukan ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tanggal: ${DateFormat('dd MMM yyyy').format(tanggal)}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        'Lokasi: ${lokasi.length > 20 ? '${lokasi.substring(0, 20)}...' : lokasi}',
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Icon edit & delete horizontal
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      color: Colors.teal,
                      onPressed: () => _showDetail(item),
                      tooltip: 'Detail',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () => _handleEdit(item),
                      tooltip: 'Edit',
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => _handleDelete(item['id']),
                      tooltip: 'Hapus',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

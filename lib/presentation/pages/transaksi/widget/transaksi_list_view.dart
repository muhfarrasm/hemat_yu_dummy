import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:intl/intl.dart';

class _TransaksiListView extends StatefulWidget {
  final String endpoint;
  final bool isPemasukan;

  const _TransaksiListView({
    required this.endpoint,
    required this.isPemasukan,
  });

  @override
  State<_TransaksiListView> createState() => _TransaksiListViewState();
}

class _TransaksiListViewState extends State<_TransaksiListView> {
  final ServiceHttpClient _httpClient = ServiceHttpClient();
  final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
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

    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        final item = data[i];
        final jumlah = double.tryParse(item['jumlah'].toString()) ?? 0;
        final tanggal = DateTime.tryParse(item['tanggal'] ?? '') ?? DateTime.now();
        final lokasi = item['lokasi'] ?? '-';

        return Card(
          child: ListTile(
            title: Text(formatter.format(jumlah),
                style: TextStyle(
                  color: widget.isPemasukan ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text(
              'Tanggal: ${DateFormat('dd MMM yyyy').format(tanggal)}\nLokasi: $lokasi',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}

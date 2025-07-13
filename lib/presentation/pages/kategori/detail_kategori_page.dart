import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/kategori/kategori_response.dart';
import 'package:hematyu_app_dummy_fix/data/repository/kategori_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class DetailKategoriPage extends StatefulWidget {
  final JenisKategori jenis;
  final int id;

  const DetailKategoriPage({super.key, required this.jenis, required this.id});
  @override
  State<DetailKategoriPage> createState() => _DetailKategoriPageState();
}

class _DetailKategoriPageState extends State<DetailKategoriPage> {
  late Future<KategoriResponse> _kategoriFuture;

  @override
  void initState() {
    super.initState();
    _kategoriFuture = KategoriRepository(
      ServiceHttpClient(),
    ).getDetailKategori(type: widget.jenis, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Kategori")),
      body: FutureBuilder<KategoriResponse>(
        future: _kategoriFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("❌ ${snapshot.error}"));
          }

          final kategori = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Deskripsi: ${kategori.deskripsi ?? '-'}"),
              const SizedBox(height: 10),
              if (widget.jenis == JenisKategori.target) ...[
                Text(
                  "Total Terkumpul: Rp${kategori.totalTerkumpul?.toStringAsFixed(0) ?? '0'}",
                ),
                Text(
                  "Total Target Dana: Rp${kategori.totalTargetDana?.toStringAsFixed(0) ?? '0'}",
                ),
                LinearProgressIndicator(
                  value: (kategori.persentasePencapaian ?? 0) / 100,
                  minHeight: 8,
                ),
                const SizedBox(height: 12),
                ...?kategori.targets?.map(
                  (target) => Card(
                    child: ListTile(
                      title: Text(target['nama_target']),
                      subtitle: Text(
                        "Rp${target['terkumpul']} / Rp${target['target_dana']}",
                      ),
                      trailing: Icon(
                        Icons.circle,
                        color:
                            target['status'] == 'aktif'
                                ? Colors.green
                                : Colors.red,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
              if (widget.jenis == JenisKategori.pemasukan) ...[
                ...?kategori.pemasukan?.map(
                  (item) => Card(
                    child: ListTile(
                      title: Text("Rp${item['jumlah']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['deskripsi'] ?? '-'),
                          Text(item['tanggal'] ?? '-'),
                          Text(item['lokasi'] ?? '-'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              if (widget.jenis == JenisKategori.pengeluaran) ...[
                Text(
                  "Anggaran: Rp${kategori.anggaran?.toStringAsFixed(0) ?? '0'}",
                ),
                Text(
                  "Total Pengeluaran: Rp${kategori.totalPengeluaran?.toStringAsFixed(0) ?? '0'}",
                ),
                Text(
                  "Sisa Anggaran: Rp${kategori.sisaAnggaran?.toStringAsFixed(0) ?? '0'}",
                ),
                const SizedBox(height: 12),
                ...?kategori.pengeluaran?.map(
                  (item) => Card(
                    child: ListTile(
                      title: Text("Rp${item['jumlah']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item['deskripsi'] != null)
                            Text(item['deskripsi']),
                          Text(item['tanggal']),
                          Text(item['lokasi']),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

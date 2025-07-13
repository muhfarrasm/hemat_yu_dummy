import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: AppColors.lightTextColor,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primaryColor,
              ),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Kembali',
            ),
          ),
        ),
        title: const Text(
          "Detail Kategori",
          style: TextStyle(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.w800,
            fontSize: 24,
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
          ),
        ),
        child: FutureBuilder<KategoriResponse>(
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
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.description_rounded,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Deskripsi: ${kategori.deskripsi ?? '-'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (widget.jenis == JenisKategori.target) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Rekap Target",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Total Terkumpul: Rp${kategori.totalTerkumpul?.toStringAsFixed(0) ?? '0'}",
                          ),
                          Text(
                            "Total Target Dana: Rp${kategori.totalTargetDana?.toStringAsFixed(0) ?? '0'}",
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (kategori.persentasePencapaian ?? 0) / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${kategori.persentasePencapaian?.toStringAsFixed(1) ?? '0'}% tercapai",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...?kategori.targets?.map((target) {
                    final double terkumpul =
                        double.tryParse(target['terkumpul'].toString()) ?? 0;
                    final double targetDana =
                        double.tryParse(target['target_dana'].toString()) ?? 1;
                    final double persen = (terkumpul / targetDana) * 100;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.flag_rounded,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    target['nama_target'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Icon(
                                  target['status'] == 'aktif'
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  color:
                                      target['status'] == 'aktif'
                                          ? AppColors.successColor
                                          : AppColors.errorColor,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rp${terkumpul.toStringAsFixed(0)} / Rp${targetDana.toStringAsFixed(0)}",
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: (persen / 100).clamp(0, 1),
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${persen.toStringAsFixed(1)}% tercapai",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                if (widget.jenis == JenisKategori.pemasukan) ...[
                  ...?kategori.pemasukan?.map(
                    (item) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.attach_money_rounded,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rp${item['jumlah']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (item['deskripsi'] != null)
                                    Text(item['deskripsi']),
                                  Text(item['tanggal'] ?? '-'),
                                  Text(item['lokasi'] ?? '-'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                if (widget.jenis == JenisKategori.pengeluaran) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Rekap Pengeluaran",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Anggaran: Rp${kategori.anggaran?.toStringAsFixed(0) ?? '0'}",
                          ),
                          Text(
                            "Total Pengeluaran: Rp${kategori.totalPengeluaran?.toStringAsFixed(0) ?? '0'}",
                          ),
                          Text(
                            "Sisa Anggaran: Rp${kategori.sisaAnggaran?.toStringAsFixed(0) ?? '0'}",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...?kategori.pengeluaran?.map(
                    (item) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.money_off_rounded,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rp${item['jumlah']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (item['deskripsi'] != null)
                                    Text(item['deskripsi']),
                                  Text(item['tanggal'] ?? '-'),
                                  Text(item['lokasi'] ?? '-'),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}

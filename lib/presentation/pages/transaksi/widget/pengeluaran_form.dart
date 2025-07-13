import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_state.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_state.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';

class PengeluaranForm extends StatefulWidget {
  final TextEditingController jumlahController;
  final TextEditingController tanggalController;
  final TextEditingController deskripsiController;
  final int? selectedKategoriId;
  final Function(int?) onKategoriChanged;
  final VoidCallback onPilihBukti;
  final VoidCallback onPilihLokasi;
  final String? buktiPath;
  final String lokasi;
  final bool isEdit;
  final int? transaksiId;
  final String submitLabel;

  const PengeluaranForm({
    super.key,
    required this.jumlahController,
    required this.tanggalController,
    required this.deskripsiController,
    required this.selectedKategoriId,
    required this.onKategoriChanged,
    required this.onPilihBukti,
    required this.onPilihLokasi,
    this.buktiPath,
    required this.lokasi,
    this.isEdit = false,
    this.transaksiId,
    this.submitLabel = 'Simpan Pengeluaran',
  });

  @override
  State<PengeluaranForm> createState() => _PengeluaranFormState();
}

class _PengeluaranFormState extends State<PengeluaranForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<KategoriBloc>().add(FetchKategori(JenisKategori.pengeluaran));
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() != true) return;

    final data = {
      "jumlah": widget.jumlahController.text,
      "tanggal": widget.tanggalController.text,
      "kategori_id": widget.selectedKategoriId,
      "deskripsi": widget.deskripsiController.text,
      "bukti_transaksi": widget.buktiPath ?? "",
      "lokasi": widget.lokasi,
    };

    if (widget.isEdit && widget.transaksiId != null) {
      context.read<TransaksiBloc>().add(
        UpdatePengeluaran(widget.transaksiId!, data),
      );
    } else {
      context.read<TransaksiBloc>().add(SubmitPengeluaran(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransaksiBloc, TransaksiState>(
      listener: (context, state) {
        if (state is TransaksiLoading) {
          // Tampilkan loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          // Tutup loading dialog jika masih terbuka
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop(); // Tutup dialog
          }

          if (state is TransaksiSuccess && mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));

            // Pastikan hanya pop form page, bukan back to Welcome
            Future.delayed(const Duration(milliseconds: 500), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); 
              }
            });
          } else if (state is TransaksiError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        }
      },

      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah', prefixIcon: Icon(Icons.attach_money_rounded),),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Jumlah wajib diisi'
                          : null,
            ),
            const SizedBox(height: 16),

            
            BlocBuilder<KategoriBloc, KategoriState>(
              builder: (context, state) {
                if (state is KategoriLoading) {
                  return const CircularProgressIndicator();
                } else if (state is KategoriLoaded) {
                  final kategoriList = state.kategoriList;

                  return DropdownButtonFormField<int>(
                    value:
                        kategoriList.any(
                              (e) => e.id == widget.selectedKategoriId,
                            )
                            ? widget.selectedKategoriId
                            : null,
                    onChanged: widget.onKategoriChanged,
                    items:
                        kategoriList.map((kategori) {
                          return DropdownMenuItem<int>(
                            value: kategori.id,
                            child: Text(kategori.namaKategori),
                          );
                        }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Kategori Pengeluaran', prefixIcon: Icon(Icons.category_rounded),
                    ),
                    validator:
                        (value) =>
                            value == null ? 'Kategori harus dipilih' : null,
                  );
                } else if (state is KategoriError) {
                  return Text('Gagal memuat kategori: ${state.message}');
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: widget.tanggalController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Tanggal', prefixIcon: Icon(Icons.calendar_today_rounded),),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  widget.tanggalController.text = picked
                      .toIso8601String()
                      .substring(0, 10);
                }
              },
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Tanggal wajib diisi'
                          : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: widget.deskripsiController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (opsional)',  prefixIcon: Icon(Icons.description_rounded),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: widget.onPilihBukti,
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: const Text('Upload Bukti'),
                   style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, 
                    foregroundColor: AppColors.lightTextColor, 
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.buktiPath ?? 'Belum ada file',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (widget.buktiPath != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      widget.buktiPath!.startsWith('/data/')
                          ? Image.file(
                            File(widget.buktiPath!),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                          : Image.network(
                            'http://192.168.48.61:8000/storage/${widget.buktiPath!}',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Text('Gagal memuat bukti lama'),
                          ),
                ),
              ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: widget.lokasi,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Lokasi', prefixIcon: Icon(Icons.location_on_rounded),),
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: widget.onPilihLokasi,
                icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
                label: const Text("Tambah Lokasi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, 
                  foregroundColor: AppColors.lightTextColor, 
                ),
              ),
            ),
            const SizedBox(height: 16),

           Center(
              child: ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: Text(widget.submitLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, 
                  foregroundColor: AppColors.lightTextColor, 
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
           ),
          ],
        ),
      ),
    );
  }
}

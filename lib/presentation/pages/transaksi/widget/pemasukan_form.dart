import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_state.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_state.dart';

class PemasukanForm extends StatefulWidget {
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

  const PemasukanForm({
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
    this.submitLabel = "Simpan Pemasukan",
  });

  @override
  State<PemasukanForm> createState() => _PemasukanFormState();
}

class _PemasukanFormState extends State<PemasukanForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<KategoriBloc>().add(FetchKategoriPemasukan());
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
        UpdatePemasukan(widget.transaksiId!, data),
      );
    } else {
      context.read<TransaksiBloc>().add(SubmitPemasukan(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransaksiBloc, TransaksiState>(
      listener: (context, state) {
        listener:
        (context, state) {
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
                  Navigator.of(context).pop(); // ⬅️ Ini hanya akan pop form-nya
                }
              });
            } else if (state is TransaksiError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          }
        };
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Jumlah wajib diisi'
                          : null,
            ),
            const SizedBox(height: 16),

            // ✅ FIXED: Kategori Dropdown
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
                      labelText: 'Kategori Pemasukan',
                    ),
                    validator:
                        (value) => value == null ? 'Pilih kategori' : null,
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
              decoration: const InputDecoration(labelText: 'Tanggal'),
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
                labelText: 'Deskripsi (opsional)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            // Upload Bukti Transaksi
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: widget.onPilihBukti,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Bukti'),
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
                            'http://192.168.185.61:8000/storage/${widget.buktiPath!}',
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
              decoration: const InputDecoration(labelText: 'Lokasi'),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: widget.onPilihLokasi,
                icon: const Icon(Icons.location_on),
                label: const Text("Tambah Lokasi"),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.submitLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

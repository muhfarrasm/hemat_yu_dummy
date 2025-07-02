import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_state.dart';

class PengeluaranForm extends StatefulWidget {
  final TextEditingController jumlahController;
  final TextEditingController tanggalController;
  final TextEditingController deskripsiController;
  final int? selectedKategoriId;
  final Function(int?) onKategoriChanged;
  final VoidCallback onPilihBukti;
  final String? buktiPath;

  const PengeluaranForm({
    super.key,
    required this.jumlahController,
    required this.tanggalController,
    required this.deskripsiController,
    required this.selectedKategoriId,
    required this.onKategoriChanged,
    required this.onPilihBukti,
    this.buktiPath,
  });

  @override
  State<PengeluaranForm> createState() => _PengeluaranFormState();
}

class _PengeluaranFormState extends State<PengeluaranForm> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState?.validate() != true) return;

    final data = {
      "jumlah": widget.jumlahController.text,
      "tanggal": widget.tanggalController.text,
      "kategori_id": widget.selectedKategoriId.toString(),
      "deskripsi": widget.deskripsiController.text,
      "bukti_transaksi": widget.buktiPath ?? "",
      "lokasi": "Lokasi Dinamis", // akan diganti nanti dengan GPS
    };

    context.read<TransaksiBloc>().add(SubmitPengeluaran(data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransaksiBloc, TransaksiState>(
      listener: (context, state) {
        if (state is TransaksiLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is TransaksiSuccess) {
          Navigator.pop(context); // close dialog
          Navigator.pop(context); // back
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is TransaksiError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
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
              decoration: const InputDecoration(labelText: 'Jumlah'),
              validator: (value) => value == null || value.isEmpty ? 'Jumlah wajib diisi' : null,
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
                  widget.tanggalController.text = picked.toIso8601String().substring(0, 10);
                }
              },
              validator: (value) => value == null || value.isEmpty ? 'Tanggal wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              value: widget.selectedKategoriId,
              onChanged: widget.onKategoriChanged,
              items: const [
                DropdownMenuItem(value: 3, child: Text('Makan')),
                DropdownMenuItem(value: 4, child: Text('Transportasi')),
                DropdownMenuItem(value: 5, child: Text('Belanja')),
              ],
              decoration: const InputDecoration(labelText: 'Kategori Pengeluaran'),
              validator: (value) => value == null ? 'Pilih kategori' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: widget.deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi (opsional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Simpan Pengeluaran"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

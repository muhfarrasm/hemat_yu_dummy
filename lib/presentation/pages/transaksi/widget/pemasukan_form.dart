import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_state.dart';

class PemasukanForm extends StatefulWidget  {
  final TextEditingController jumlahController;
  final TextEditingController tanggalController;
  final TextEditingController deskripsiController;
  final int? selectedKategoriId;
  final Function(int?) onKategoriChanged;
  final VoidCallback onPilihBukti;
  final String? buktiPath;

  const PemasukanForm({
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
  State<PemasukanForm> createState() => _PemasukanFormState();

}

class _PemasukanFormState extends State<PemasukanForm> {
  final _formKey = GlobalKey<FormState>(); // ✅ Ditambahkan: form key

  void _submitForm() {
    if (_formKey.currentState?.validate() != true) return;

    final data = {
      "jumlah": widget.jumlahController.text,
      "tanggal": widget.tanggalController.text,
      "kategori_id": widget.selectedKategoriId.toString(),
      "deskripsi": widget.deskripsiController.text,
      "bukti_transaksi": widget.buktiPath ?? "",
      "lokasi": "Jogja", // Nanti ganti dengan lokasi GPS dinamis
    };

    context.read<TransaksiBloc>().add(SubmitPemasukan(data)); // ✅ Ditambahkan
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransaksiBloc, TransaksiState>( // ✅ Ditambahkan: listen state
      listener: (context, state) {
        if (state is TransaksiLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is TransaksiSuccess) {
          Navigator.pop(context); // Close loading
          Navigator.pop(context); // Back to previous page
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is TransaksiError) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Form(
        key: _formKey, // ✅ Ditambahkan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
              validator: (value) => value == null || value.isEmpty ? 'Jumlah tidak boleh kosong' : null,
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
                DropdownMenuItem(value: 1, child: Text('Gaji')),
                DropdownMenuItem(value: 2, child: Text('Bonus')),
              ],
              decoration: const InputDecoration(labelText: 'Kategori Pemasukan'),
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
                onPressed: _submitForm, // ✅ Ditambahkan
                child: const Text("Simpan Pemasukan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  


import 'package:flutter/material.dart';

class PengeluaranForm extends StatelessWidget {
  final TextEditingController jumlahController;
  final TextEditingController tanggalController;
  final TextEditingController deskripsiController;
  final int? selectedKategoriId;
  final Function(int?) onKategoriChanged;
  final VoidCallback onPilihBukti;
  final String? buktiPath;
  final String? lokasi;

  const PengeluaranForm({
    super.key,
    required this.jumlahController,
    required this.tanggalController,
    required this.deskripsiController,
    required this.selectedKategoriId,
    required this.onKategoriChanged,
    required this.onPilihBukti,
    this.buktiPath,
    this.lokasi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: jumlahController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Jumlah'),
          validator: (value) =>
              value == null || value.isEmpty ? 'Jumlah tidak boleh kosong' : null,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: tanggalController,
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
              tanggalController.text = picked.toIso8601String().substring(0, 10);
            }
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Tanggal wajib diisi' : null,
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<int>(
          value: selectedKategoriId,
          onChanged: onKategoriChanged,
          items: const [
            // Nanti diisi dari API
            DropdownMenuItem(value: 1, child: Text('Makan')),
            DropdownMenuItem(value: 2, child: Text('Transportasi')),
          ],
          decoration: const InputDecoration(labelText: 'Kategori Pengeluaran'),
          validator: (value) => value == null ? 'Pilih kategori' : null,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: deskripsiController,
          decoration: const InputDecoration(labelText: 'Deskripsi (opsional)'),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onPilihBukti,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Bukti'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                buktiPath ?? 'Belum ada file',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                lokasi ?? 'Lokasi belum terdeteksi',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class AddTransaksiPage extends StatefulWidget {
  const AddTransaksiPage({super.key});

  @override
  State<AddTransaksiPage> createState() => _AddTransaksiPageState();
}

class _AddTransaksiPageState extends State<AddTransaksiPage> {
  final _formKey = GlobalKey<FormState>();
  bool isPemasukan = true;

  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  int? selectedKategoriId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ToggleButtons(
                isSelected: [isPemasukan, !isPemasukan],
                onPressed: (index) {
                  setState(() => isPemasukan = index == 0);
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pemasukan'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pengeluaran'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

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
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    tanggalController.text = date.toIso8601String().substring(0, 10);
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Tanggal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // TODO: Dropdown kategori (API)
              const Text("Dropdown kategori (belum diisi)"),
              const SizedBox(height: 16),

              TextFormField(
                controller: deskripsiController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Deskripsi (opsional)'),
              ),
              const SizedBox(height: 16),

              // TODO: Upload bukti transaksi (kamera/gallery)
              const Text("Upload bukti transaksi (belum diisi)"),
              const SizedBox(height: 16),

              // TODO: Lokasi GPS
              const Text("Lokasi GPS (auto)"),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Call Bloc to add transaksi
                    print('Submit Transaksi');
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hematyu_app_dummy_fix/data/repository/kategori_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class FormTargetPage extends StatefulWidget {
  final bool isEdit; //PARAMETER edit atau tambah
  // Jika isEdit true, maka akan mengisi form dengan data yang ada di initialData
  final Map<String, dynamic>? initialData;

  const FormTargetPage({super.key, this.isEdit = false, this.initialData});

  @override
  State<FormTargetPage> createState() => _FormTargetPageState();
}

class _FormTargetPageState extends State<FormTargetPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _danaController;
  late TextEditingController _alokasiController;
  DateTime? _selectedDate;

  List<Map<String, dynamic>> _kategoriList = [];
  int? _selectedKategoriId;

  List<Map<String, dynamic>> _pemasukanList = [];
  int? _selectedPemasukanId;

  List<Map<String, dynamic>> _kategoriPengeluaranList = [];
  int? _selectedKategoriPengeluaranId;

  @override
  void initState() {
    super.initState();

    _namaController = TextEditingController(
      text: widget.initialData?['nama_target'] ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.initialData?['deskripsi'] ?? '',
    );
    _danaController = TextEditingController(
      text: widget.initialData?['target_dana']?.toString() ?? '',
    );

    _alokasiController = TextEditingController();
    final tanggal = widget.initialData?['target_tanggal'];
    if (tanggal != null) {
      _selectedDate = DateTime.tryParse(tanggal);
    }

    _selectedKategoriId = widget.initialData?['kategori_target_id'];

    _fetchKategori();
    _fetchKategoriPengeluaran();
    _fetchPemasukan();
  }

  Future<void> _fetchKategori() async {
    try {
      final repo = KategoriRepository(ServiceHttpClient());
      final result = await repo.getKategoriTarget();
      setState(() {
        _kategoriList =
            result
                .map(
                  (item) => {'id': item.id, 'nama_kategori': item.namaKategori},
                )
                .toList();
      });
    } catch (e) {
      _showError('Gagal mengambil data kategori');
    }
  }

  Future<void> _fetchPemasukan() async {
    try {
      final client = ServiceHttpClient();
      final response = await client.get('/pemasukan', authorized: true);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List list = json['data'];
        setState(() {
          _pemasukanList =
              list.map((e) {
                return {
                  'id': e['id'],
                  'deskripsi': e['deskripsi'] ?? '-',
                  'jumlah': e['jumlah'],
                };
              }).toList();
        });
      }
    } catch (e) {
      _showError('Gagal mengambil data pemasukan');
    }
  }

  Future<void> _fetchKategoriPengeluaran() async {
    try {
      final client = ServiceHttpClient();
      final response = await client.get(
        '/kategori-pengeluaran',
        authorized: true,
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List list = json['data'];
        setState(() {
          _kategoriPengeluaranList =
              list
                  .map(
                    (e) => {'id': e['id'], 'nama_kategori': e['nama_kategori']},
                  )
                  .toList();
        });
      }
    } catch (e) {
      _showError('Gagal mengambil kategori pengeluaran');
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _danaController.dispose();
    _alokasiController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) return;

    final body = {
      'nama_target': _namaController.text.trim(),
      'deskripsi': _deskripsiController.text.trim(),
      'target_dana': double.tryParse(_danaController.text.trim()) ?? 0,
      'target_tanggal': _selectedDate!.toIso8601String(),
      'kategori_target_id': _selectedKategoriId,
    };

    try {
      // Kirim API request
      final client = ServiceHttpClient(); // Pastikan ada file ini
      final response =
          widget.isEdit
              ? await client.put('/target/${widget.initialData!['id']}', body)
              : await client.post('/target', body, authorized: true);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!widget.isEdit) {
          final targetId = jsonDecode(response.body)['data']['id'];
          final jumlahAlokasi = double.tryParse(_alokasiController.text.trim());

          final alokasiBody = {
            'id_target': targetId,
            'id_pemasukan': _selectedPemasukanId,
            'jumlah_alokasi': jumlahAlokasi,
          };

          final alokasiResponse = await client.post(
            '/relasi-target-pemasukan',
            alokasiBody,
            authorized: true,
          );

          if (!(alokasiResponse.statusCode == 200 ||
              alokasiResponse.statusCode == 201)) {
            _showError('Target tersimpan tapi gagal alokasi');
            return;
          }

          final pengeluaranBody = {
            'jumlah': jumlahAlokasi,
            'deskripsi': 'Alokasi dana untuk target ID: $targetId',
            'tanggal': DateFormat('yyyy-MM-dd').format(DateTime.now()),
            'kategori_id':
                _selectedKategoriPengeluaranId, // pakai kategori target juga
          };

          final pengeluaranResponse = await client.post(
            '/pengeluaran',
            pengeluaranBody,
            authorized: true,
          );
          print('STATUS PENGELUARAN: ${pengeluaranResponse.statusCode}');
          print('BODY PENGELUARAN: ${pengeluaranResponse.body}');

          if (!(pengeluaranResponse.statusCode == 200 ||
              pengeluaranResponse.statusCode == 201)) {
            _showError(
              'Target dan alokasi tersimpan, tapi gagal mencatat pengeluaran.',
            );
            return;
          }
        }

        Navigator.pop(context, true);
      } else {
        _showError('Gagal menyimpan target');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Target' : 'Tambah Target')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Target'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),

              DropdownButtonFormField<int>(
                value: _selectedKategoriId,
                items:
                    _kategoriList.map((item) {
                      return DropdownMenuItem<int>(
                        value: item['id'],
                        child: Text(item['nama_kategori']),
                      );
                    }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedKategoriId = val;
                  });
                },
                decoration: const InputDecoration(labelText: 'Kategori Target'),
                validator:
                    (val) =>
                        val == null ? 'Pilih kategori terlebih dahulu' : null,
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextFormField(
                controller: _danaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Dana'),
                validator: (value) {
                  final num = double.tryParse(value ?? '');
                  if (num == null || num <= 0) return 'Harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Pilih tanggal target'
                          : DateFormat('dd MMM yyyy').format(_selectedDate!),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Pilih Tanggal'),
                  ),
                ],
              ),
              if (!isEdit) ...[
                DropdownButtonFormField<int>(
                  value: _selectedPemasukanId,
                  items:
                      _pemasukanList.map((item) {
                        return DropdownMenuItem<int>(
                          value: item['id'],
                          child: Text(
                            '${item['deskripsi']} (Rp ${item['jumlah']})',
                          ),
                        );
                      }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedPemasukanId = val;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pilih Pemasukan',
                  ),
                  validator:
                      (val) =>
                          val == null
                              ? 'Pilih pemasukan terlebih dahulu'
                              : null,
                ),
                TextFormField(
                  controller: _alokasiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Alokasi',
                  ),
                  validator: (val) {
                    final amount = double.tryParse(val ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Masukkan jumlah yang valid';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _selectedKategoriPengeluaranId,
                  items:
                      _kategoriPengeluaranList.map((item) {
                        return DropdownMenuItem<int>(
                          value: item['id'],
                          child: Text(item['nama_kategori']),
                        );
                      }).toList(),
                  onChanged:
                      (val) =>
                          setState(() => _selectedKategoriPengeluaranId = val),
                  decoration: const InputDecoration(
                    labelText: 'Kategori Pengeluaran',
                  ),
                  validator:
                      (val) =>
                          val == null ? 'Pilih kategori pengeluaran' : null,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? 'Update' : 'Simpan'),
              ),
            ],
          ),
        ),

        // Jika mode tambah, tampilkan alokasi pemasukan
      ),
    );
  }
}

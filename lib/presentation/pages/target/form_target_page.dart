import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart';
import 'package:hematyu_app_dummy_fix/data/repository/kategori_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class FormTargetPage extends StatefulWidget {
  final bool isEdit;
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

    context.read<KategoriBloc>().add(FetchKategori(JenisKategori.target));
    _fetchKategori();
    _fetchKategoriPengeluaran();
    _fetchPemasukan();
  }

  Future<void> _fetchKategori() async {
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
  }

  Future<void> _fetchPemasukan() async {
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
  }

  Future<void> _fetchKategoriPengeluaran() async {
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

    final client = ServiceHttpClient();
    final response =
        widget.isEdit
            ? await client.put(
              '/target/${widget.initialData!['id']}',
              body,
              authorized: true,
            )
            : await client.post('/target', body, authorized: true);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan target'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        title: Text(
          widget.isEdit ? 'Edit Kategori' : 'Tambah Kategori',
          style: const TextStyle(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Target',
                  prefixIcon: Icon(Icons.flag),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedKategoriId,
                items:
                    _kategoriList
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: item['id'],
                            child: Text(item['nama_kategori']),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedKategoriId = val;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Kategori Target',
                  prefixIcon: Icon(Icons.category),
                ),
                validator:
                    (val) =>
                        val == null ? 'Pilih kategori terlebih dahulu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _danaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Dana',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  final num = double.tryParse(value ?? '');
                  if (num == null || num <= 0) return 'Harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Pilih tanggal target'
                          : DateFormat('dd MMM yyyy').format(_selectedDate!),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: const Text('Pilih Tanggal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.lightTextColor,
                    ),
                  ),
                ],
              ),

              if (!isEdit) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedPemasukanId,
                  items:
                      _pemasukanList
                          .map(
                            (item) => DropdownMenuItem<int>(
                              value: item['id'],
                              child: Text(
                                '${item['deskripsi']} (Rp ${item['jumlah']})',
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedPemasukanId = val;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pilih Pemasukan',
                    prefixIcon: Icon(Icons.account_balance_wallet),
                  ),
                  validator:
                      (val) =>
                          val == null
                              ? 'Pilih pemasukan terlebih dahulu'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _alokasiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Alokasi',
                    prefixIcon: Icon(Icons.money_off_csred_rounded),
                  ),
                  validator: (val) {
                    final amount = double.tryParse(val ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Masukkan jumlah yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedKategoriPengeluaranId,
                  items:
                      _kategoriPengeluaranList
                          .map(
                            (item) => DropdownMenuItem<int>(
                              value: item['id'],
                              child: Text(item['nama_kategori']),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedKategoriPengeluaranId = val;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Kategori Pengeluaran',
                    prefixIcon: Icon(Icons.money),
                  ),
                  validator:
                      (val) =>
                          val == null ? 'Pilih kategori pengeluaran' : null,
                ),
              ],

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(isEdit ? 'Update Target' : 'Simpan Target'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.lightTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

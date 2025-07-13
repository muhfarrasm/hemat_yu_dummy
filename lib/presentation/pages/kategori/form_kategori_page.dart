import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/core/constants/colors.dart'; // ✅ Pastikan impor warna
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/kategori/kategori_response.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';

class FormKategoriPage extends StatefulWidget {
  final JenisKategori jenis;
  final bool isEdit;
  final KategoriResponse? initialData;

  const FormKategoriPage({
    super.key,
    required this.jenis,
    this.isEdit = false,
    this.initialData,
  });

  @override
  State<FormKategoriPage> createState() => _FormKategoriPageState();
}

class _FormKategoriPageState extends State<FormKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _deskripsiCtrl = TextEditingController();
  final TextEditingController _anggaranCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.initialData != null) {
      _namaCtrl.text = widget.initialData!.namaKategori;
      _deskripsiCtrl.text = widget.initialData!.deskripsi ?? '';
      if (widget.jenis == JenisKategori.pengeluaran) {
        _anggaranCtrl.text =
            widget.initialData!.anggaran?.toStringAsFixed(0) ?? '';
      }
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _deskripsiCtrl.dispose();
    _anggaranCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaCtrl.text.trim();
    final deskripsi = _deskripsiCtrl.text.trim();
    final anggaran = widget.jenis == JenisKategori.pengeluaran
        ? double.tryParse(_anggaranCtrl.text.trim())
        : null;

    final bloc = context.read<KategoriBloc>();

    if (widget.isEdit) {
      bloc.add(UpdateKategori(
        type: widget.jenis,
        id: widget.initialData!.id,
        nama: nama,
        deskripsi: deskripsi,
        anggaran: anggaran,
      ));
    } else {
      bloc.add(AddKategori(
        type: widget.jenis,
        nama: nama,
        deskripsi: deskripsi,
        anggaran: anggaran,
      ));
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // ✅ AppBar tanpa shadow
        backgroundColor: Colors.transparent, // ✅ AppBar transparan
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
            backgroundColor: AppColors.lightTextColor, // ✅ Circle putih
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
      backgroundColor: AppColors.backgroundColor, // ✅ Latar belakang terang
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Kategori',
                  border: OutlineInputBorder(), // ✅ Konsisten input style
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiCtrl,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(), // ✅
                ),
                maxLines: 3,
              ),
              if (widget.jenis == JenisKategori.pengeluaran) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _anggaranCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Anggaran',
                    border: OutlineInputBorder(), // ✅
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.save),
                  label: Text(widget.isEdit ? 'Simpan Perubahan' : 'Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, // ✅ Tombol hijau
                    foregroundColor: AppColors.lightTextColor, // ✅ Teks putih
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

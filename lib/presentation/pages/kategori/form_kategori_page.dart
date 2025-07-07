import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    Navigator.pop(context, true); // Kembali setelah submit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Kategori' : 'Tambah Kategori'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Kategori'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deskripsiCtrl,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              if (widget.jenis == JenisKategori.pengeluaran) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _anggaranCtrl,
                  decoration: const InputDecoration(labelText: 'Anggaran'),
                  keyboardType: TextInputType.number,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.save),
                label: Text(widget.isEdit ? 'Simpan Perubahan' : 'Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

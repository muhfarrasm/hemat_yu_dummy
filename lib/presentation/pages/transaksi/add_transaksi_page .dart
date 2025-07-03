import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ Tambahan untuk BlocListener
import 'package:hematyu_app_dummy_fix/presentation/camera/bloc/camera_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/camera/bloc/camera_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/camera/camera_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/camera/storage_helper.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_state.dart';
import 'package:hematyu_app_dummy_fix/core/maps/map_picker_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/widget/pemasukan_form.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/widget/pengeluaran_form.dart';
import 'package:hematyu_app_dummy_fix/presentation/transaksi/bloc/transaksi_bloc.dart'; // ✅ Import Bloc
import 'package:permission_handler/permission_handler.dart';

class AddTransaksiPage extends StatefulWidget {
  final bool isEdit;
  final bool isPemasukan;
  final int? transaksiId;
  final Map<String, dynamic>? initialData;

  const AddTransaksiPage({
    super.key,
    this.isEdit = false,
    this.isPemasukan = true,
    this.transaksiId,
    this.initialData,
  });

  @override
  State<AddTransaksiPage> createState() => _AddTransaksiPageState();
}

class _AddTransaksiPageState extends State<AddTransaksiPage> {
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  int? selectedKategoriId;
  String? buktiPath;
  bool isPemasukanLocal = true;

  @override
  void initState() {
    super.initState();
    isPemasukanLocal = widget.isPemasukan;

    if (widget.isEdit && widget.initialData != null) {
      final data = widget.initialData!;
      jumlahController.text = data['jumlah']?.toString() ?? '';
      tanggalController.text = data['tanggal']?.toString().substring(0, 10) ?? '';
      deskripsiController.text = data['deskripsi'] ?? '';
      lokasiController.text = data['lokasi'] ?? '';
      selectedKategoriId = data['kategori_id'];
      buktiPath = data['bukti_transaksi'];
    }
  }

  @override
  void dispose() {
    jumlahController.dispose();
    tanggalController.dispose();
    deskripsiController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

   Future<void> _onPilihBukti() async {
  final status = await Permission.camera.request();

  if (status.isGranted) {
    final bloc = context.read<CameraBloc>();
    final File? file = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const CameraPage(),
        ),
      ),
    );

    if (file != null) {
      final saved = await StorageHelper.saveImage(file, 'pemasukan');
      setState(() {
        buktiPath = saved.path;
      });
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Akses kamera ditolak')),
    );
  }
}

  Future<void> _pilihLokasi() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerPage()),
    );

    if (result != null) {
      setState(() {
        lokasiController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Tambahkan BlocListener untuk menangani success/error state
    return BlocListener<TransaksiBloc, TransaksiState>(
      listener: (context, state) {
        if (state is TransaksiSuccess) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pop(context);
        } else if (state is TransaksiError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEdit ? 'Edit Transaksi' : 'Tambah Transaksi'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              ToggleButtons(
                isSelected: [isPemasukanLocal, !isPemasukanLocal],
                onPressed: widget.isEdit
                    ? null
                    : (index) {
                        setState(() {
                          isPemasukanLocal = index == 0;
                        });
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

              isPemasukanLocal
                  ? PemasukanForm(
                      jumlahController: jumlahController,
                      tanggalController: tanggalController,
                      deskripsiController: deskripsiController,
                      selectedKategoriId: selectedKategoriId,
                      onKategoriChanged: (id) {
                        setState(() {
                          selectedKategoriId = id;
                        });
                      },
                      onPilihBukti: _onPilihBukti,
                      buktiPath: buktiPath,
                      lokasi: lokasiController.text,
                      onPilihLokasi: _pilihLokasi,
                      isEdit: widget.isEdit,
                      transaksiId: widget.transaksiId,
                      submitLabel:
                          widget.isEdit ? 'Simpan Perubahan' : 'Simpan Pemasukan',
                    )
                  : PengeluaranForm(
                      jumlahController: jumlahController,
                      tanggalController: tanggalController,
                      deskripsiController: deskripsiController,
                      selectedKategoriId: selectedKategoriId,
                      onKategoriChanged: (id) {
                        setState(() {
                          selectedKategoriId = id;
                        });
                      },
                      onPilihBukti: _onPilihBukti,
                      buktiPath: buktiPath,
                      lokasi: lokasiController.text,
                      onPilihLokasi: _pilihLokasi,
                      isEdit: widget.isEdit,
                      transaksiId: widget.transaksiId,
                      submitLabel: widget.isEdit
                          ? 'Simpan Perubahan'
                          : 'Simpan Pengeluaran',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

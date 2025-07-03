import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hematyu_app_dummy_fix/core/camera/camera_page.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/widget/pemasukan_form.dart';
import 'package:hematyu_app_dummy_fix/presentation/pages/transaksi/widget/pengeluaran_form.dart';

class AddTransaksiPage extends StatefulWidget {
  const AddTransaksiPage({super.key});

  @override
  State<AddTransaksiPage> createState() => _AddTransaksiPageState();
}

class _AddTransaksiPageState extends State<AddTransaksiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  bool isPemasukan = true;
  int? selectedKategoriId;
  String? buktiPath;
  String? lokasi;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    jumlahController.dispose();
    tanggalController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _onPilihBukti() async {
    final File? result = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );

    if (result != null && mounted) {
      setState(() {
        buktiPath = result.path;
      });
    }
  }

  //lokasi GPS
  // Menggunakan Geolocator untuk mendapatkan lokasi GPS
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;
    setState(() {
      lokasi =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
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

            isPemasukan
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
                  lokasi: lokasi ?? 'Mengambil lokasi...',
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
                  lokasi: lokasi ?? 'Mengambil lokasi...',
                ),
          ],
        ),
      ),
    );
  }
}

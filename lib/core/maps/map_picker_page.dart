import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;
  String? _selectedAddress;

  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedPosition = position;
    });

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;
      setState(() {
        _selectedAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      setState(() {
        _selectedAddress = "Tidak bisa mengambil alamat";
      });
    }
  }

  void _konfirmasiLokasi() {
    if (_selectedAddress != null) {
      Navigator.pop(context, _selectedAddress);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih lokasi terlebih dahulu.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-7.797068, 110.370529),
              zoom: 14.0,
            ),
            onTap: _onMapTap,
            markers: _selectedPosition != null
                ? {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: _selectedPosition!,
                    )
                  }
                : {},
          ),
          if (_selectedAddress != null)
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(_selectedAddress!),
              ),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _konfirmasiLokasi,
              child: const Text("Konfirmasi Lokasi"),
            ),
          ),
        ],
      ),
    );
  }
}

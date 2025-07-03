import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/camera/bloc/camera_bloc.dart';
import 'package:hematyu_app_dummy_fix/presentation/camera/bloc/camera_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/camera/bloc/camera_state.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<CameraBloc>();

    // Minta permission DULU, baru init kamera
    bloc.add(RequestPermission());
  }

  IconData _flashIcon(FlashMode mode) {
    return switch (mode) {
      FlashMode.auto => Icons.flash_auto,
      FlashMode.always => Icons.flash_on,
      _ => Icons.flash_off,
    };
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return ClipOval(
      child: Material(
        color: Colors.white24,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<CameraBloc, CameraState>(
        builder: (context, state) {
          if (state is CameraError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CameraBloc>().add(RequestPermission());
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          if (state is! CameraReady) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Tampilkan snackbar jika ada pesan
          if (state.snackbarMessage != null) {
            Future.microtask(() {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.snackbarMessage!)));
              context.read<CameraBloc>().add(ClearSnackbar());
            });
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // ✅ Fokus kamera dengan tap
                  GestureDetector(
                    onTapDown: (details) {
                      context.read<CameraBloc>().add(
                        TapToFocus(details.localPosition, constraints.biggest),
                      );
                    },
                    child: CameraPreview(state.controller),
                  ),

                  // ✅ Tombol kanan atas: Switch camera & flash
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Column(
                      children: [
                        _circleButton(Icons.flip_camera_android, () {
                          context.read<CameraBloc>().add(SwitchCamera());
                        }),
                        const SizedBox(height: 12),
                        _circleButton(_flashIcon(state.flashMode), () {
                          context.read<CameraBloc>().add(ToogleFlash());
                        }),
                      ],
                    ),
                  ),

                  // ✅ Tombol kiri bawah (optional): ambil dari galeri
                  Positioned(
                    bottom: 30,
                    left: 30,
                    child: _circleButton(Icons.image, () {
                      context.read<CameraBloc>().add(PickImageFromGallery(context));
                    }),
                  ),

                  // ✅ Tombol shutter di tengah bawah
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          context.read<CameraBloc>().add(
                            TakePicture((file) => Navigator.pop(context, file)),
                          );
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

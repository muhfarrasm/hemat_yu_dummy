import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hematyu_app_dummy_fix/core/camera/storage_helper.dart';
import 'package:path/path.dart' as p;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  int _selectedCameraIdx = 0;
  FlashMode _flashMode = FlashMode.off;
  double _zoom = 1.0;
  double _maxZoom = 1.0;
  double _minZoom = 1.0;
  bool _isZoomSupported = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      if (mounted) Navigator.pop(context);
      return;
    }
    await _setupCamera(_selectedCameraIdx);
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    final controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();
    _maxZoom = await controller.getMaxZoomLevel();
    _minZoom = await controller.getMinZoomLevel();
    _isZoomSupported = _maxZoom > _minZoom;
    _zoom = _minZoom;
    await controller.setZoomLevel(_zoom);
    await controller.setFlashMode(_flashMode);

    if (mounted) {
      setState(() {
        _controller = controller;
        _selectedCameraIdx = cameraIndex;
      });
    }
  }

  Future<void> _captureImage() async {
    final XFile file = await _controller!.takePicture();
    final savedFile = await StorageHelper.saveImage(File(file.path), 'home_camera');
    Navigator.pop(context, savedFile); // Kembalikan ke page sebelumnya
  }

  void _switchCamera() {
    final nextIndex = (_selectedCameraIdx + 1) % _cameras.length;
    _setupCamera(nextIndex);
  }

  void _toggleFlash() async {
    FlashMode next = _flashMode == FlashMode.off
        ? FlashMode.auto
        : _flashMode == FlashMode.auto
            ? FlashMode.always
            : FlashMode.off;
    await _controller!.setFlashMode(next);
    setState(() => _flashMode = next);
  }

  void _setZoom(double value) async {
    if (!_isZoomSupported) return;
    _zoom = value.clamp(_minZoom, _maxZoom);
    await _controller!.setZoomLevel(_zoom);
    setState(() {});
  }

  IconData _flashIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      default:
        return Icons.flash_off;
    }
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, {double size = 50}) {
    return ClipOval(
      child: Material(
        color: Colors.white24,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapDown: (details) {
              final offset = Offset(
                details.localPosition.dx / constraints.maxWidth,
                details.localPosition.dy / constraints.maxHeight,
              );
              _controller?.setFocusPoint(offset);
              _controller?.setExposurePoint(offset);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Column(
                    children: [
                      _circleButton(Icons.flip_camera_android, _switchCamera),
                      const SizedBox(height: 12),
                      _circleButton(_flashIcon(), _toggleFlash),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: _captureImage,
                      child: const Icon(Icons.camera_alt, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

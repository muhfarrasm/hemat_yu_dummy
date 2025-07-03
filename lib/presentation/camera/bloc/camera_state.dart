import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';
import 'dart:io';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;
  final int selectedIndex;
  final FlashMode flashMode;
  final File? imageFile;
  final String? snackbarMessage;

  const CameraReady({
    required this.controller,
    required this.selectedIndex,
    required this.flashMode,
    this.imageFile,
    this.snackbarMessage,
  });

  CameraReady copyWith({
    CameraController? controller,
    int? selectedIndex,
    FlashMode? flashMode,
    File? imageFile,
    String? snackbarMessage,
    bool clearSnackbar = false,
  }) {
    return CameraReady(
      controller: controller ?? this.controller,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      flashMode: flashMode ?? this.flashMode,
      imageFile: imageFile ?? this.imageFile,
      snackbarMessage: clearSnackbar ? null : snackbarMessage ?? this.snackbarMessage,
    );
  }

  @override
  List<Object?> get props =>
      [controller, selectedIndex, flashMode, imageFile, snackbarMessage];
}

/// ✅ Tambahkan ini
class CameraError extends CameraState {
  final String message;

  const CameraError(this.message);

  @override
  List<Object?> get props => [message];
}

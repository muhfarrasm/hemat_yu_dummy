import 'dart:io';
import 'package:flutter/material.dart';

sealed class CameraEvent {}

final class InitializeCamera extends CameraEvent {}

final class SwitchCamera extends CameraEvent {}

final class ToogleFlash extends CameraEvent {}

final class TakePicture extends CameraEvent {
  final void Function(File imageFile) onPictureTaken;
  TakePicture(this.onPictureTaken);
}

final class TapToFocus extends CameraEvent {
  final Offset position;
  final Size previewSize;
  TapToFocus(this.position, this.previewSize);
}

class PickImageFromGallery extends CameraEvent {
  final BuildContext context;

  PickImageFromGallery(this.context);
}

final class OpenCameraAndCapture extends CameraEvent {
  final BuildContext context;
  OpenCameraAndCapture(this.context);
}

final class DeleteImage extends CameraEvent {}

final class ClearSnackbar extends CameraEvent {}

final class RequestPermission extends CameraEvent {}
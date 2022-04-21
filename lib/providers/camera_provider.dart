import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraProvider extends ChangeNotifier {
  List<CameraDescription> cameras = [];

  int index = 0;

  bool flash = false;

  double maxZoom = 1.0;

  CameraController? controller;

  bool error = false;

  CameraProvider() {
    getCameras();
  }

  Future<bool> getCameras() async {
    try {
      cameras = await availableCameras();
    } on CameraException {
      return false;
      // Failed to access cameras
    }
    return true;
  }

  Future<CameraSnapshot> initialize() async {
    CameraSnapshot snapshot = CameraSnapshot();
    if (cameras.isEmpty) {
      snapshot.error = await getCameras() ? null : CameraError.access;
    }
    if (cameras.isNotEmpty) {
      snapshot.error = await initCamera(cameras[0]) ? null : CameraError.init;
    } else {
      snapshot.error = CameraError.notAvailable;
      // No Available Cameras
    }
    notifyListeners();
    return snapshot;
  }

  Future<bool> initCamera(CameraDescription camera) async {
    try {
      if (controller != null) {
        await controller!.dispose();
        controller = null;
      }

      CameraController newController =
          CameraController(camera, ResolutionPreset.medium, enableAudio: true);
      await newController.initialize();
      maxZoom = await newController.getMaxZoomLevel();
      controller = newController;
      notifyListeners();
    } on CameraException {
      return false;
    }
    return true;
  }

  Future<VideoSnapshot?> recordVideo() async {
    PermissionStatus readFilesStatus = await Permission.storage.status;
    if (readFilesStatus.isLimited || readFilesStatus.isDenied) {
      await Permission.storage.request();
    }
    if (controller == null) return null;

    if (!controller!.value.isInitialized) return null;

    if (controller!.value.isRecordingVideo) return null;

    VideoSnapshot snapshot = VideoSnapshot();
    try {
      await controller!.startVideoRecording();
      return snapshot;
    } on CameraException catch (e) {
      snapshot.error = e;
      return snapshot;
    }
  }

  Future<VideoSnapshot?> stopVideoRecording() async {
    if (controller == null) return null;

    if (!controller!.value.isInitialized) return null;

    if (!controller!.value.isRecordingVideo) return null;

    VideoSnapshot snapshot = VideoSnapshot();

    try {
      snapshot.video = await controller!.stopVideoRecording();
      return snapshot;
    } on CameraException catch (e) {
      snapshot.error = e;
      return snapshot;
    }
  }

  switchLens() async {
    index = cameras.length - index > 1 ? index + 1 : 0;
    await initCamera(cameras[index]);
  }

  switchFlash() async {
    if (flash) {
      controller!.setFlashMode(FlashMode.off);
      flash = false;
    } else {
      controller!.setFlashMode(FlashMode.torch);
      flash = true;
    }
    notifyListeners();
  }

  noCameraError() {
    error = true;
    notifyListeners();
  }

  disposeCamera() {
    controller?.dispose();
    controller = null;
  }
}

class CameraSnapshot {
  CameraError? error;

  String? capturedPhoto;
  String? recordedVideo;

  bool get hasError => error != null;

  String get errorDescription => cameraErrorDescription(error);
}

enum CameraError { access, init, notAvailable, photo, video }

String cameraErrorDescription(CameraError? error) {
  return 'Failed to access the cameras.';
}

class VideoSnapshot {
  XFile? video;

  CameraException? error;

  bool get hasError => error != null;
}

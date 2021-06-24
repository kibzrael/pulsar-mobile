import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  List<CameraDescription> cameras = [];

  int index = 0;

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
    if (cameras.length > 0) {
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
          CameraController(camera, ResolutionPreset.max, enableAudio: true);
      await newController.initialize();
      controller = newController;
      notifyListeners();
    } on CameraException {
      return false;
    }
    return true;
  }

  switchLens() async {
    index = cameras.length - index > 1 ? index + 1 : 0;
    await initCamera(cameras[index]);
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

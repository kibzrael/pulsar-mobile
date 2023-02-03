import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoProvider extends ChangeNotifier {
  VideoPlayerController? _videoPlayerController;
  Duration? _videoDuration;

  bool isInitialized = false;
  bool isInitializing = false;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  Duration? get duration => _videoDuration;

  Future initializeVideo(source) async {
    isInitializing = true;
    VideoPlayerController newController = VideoPlayerController.network(source);
    VideoPlayerController? oldController = _videoPlayerController;
    if (oldController != null) {
      oldController.pause();
      oldController.removeListener(() {});
    }
    _videoPlayerController = newController;
    _videoPlayerController!.setLooping(true);
    /*
    newController
      ..initialize().then((value) {
        oldController?.dispose();
        newController.play();
        _videoDuration = newController.value.duration;
        notifyListeners();
      });*/
    await newController.initialize().catchError(onError);
    isInitialized = true;
    _videoDuration = newController.value.duration;
    oldController?.dispose();
    notifyListeners();
    return;
  }

  Future onError(Object error) async {}

  Future disposeVideo() async {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
      _videoDuration = null;
    }
    _videoDuration = null;
    notifyListeners();
  }
}

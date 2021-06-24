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
    VideoPlayerController _newController = VideoPlayerController.asset(source);
    VideoPlayerController? _oldController = _videoPlayerController;
    if (_oldController != null) {
      _oldController.pause();
      _oldController.removeListener(() {});
    }
    _videoPlayerController = _newController;
    _videoPlayerController!.setLooping(true);
    /*
    _newController
      ..initialize().then((value) {
        _oldController?.dispose();
        _newController.play();
        _videoDuration = _newController.value.duration;
        notifyListeners();
        return [_videoDuration];
      });*/
    await _newController.initialize().catchError(onError);
    isInitialized = true;
    _videoDuration = _newController.value.duration;
    await _oldController?.dispose();
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

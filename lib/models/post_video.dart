import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/video.dart';
import 'package:pulsar/providers/video_provider.dart';
import 'package:video_player/video_player.dart';

class PostVideo extends StatefulWidget {
  final Video video;

  final bool isInView;

  PostVideo(this.video, {this.isInView = false});

  @override
  _PostVideoState createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  late Video video;
  late VideoProvider videoProvider;

  VideoPlayerController? controller;

  bool videoIsInitialized = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    video = widget.video;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  initVideo() {
    videoProvider.initializeVideo(video.source);
  }

  @override
  Widget build(BuildContext context) {
    videoProvider = Provider.of<VideoProvider>(context);
    controller = videoProvider.videoPlayerController;

    // if (!videoIsInitialized && widget.isInView) {
    //   videoIsInitialized = true;

    //   videoProvider.initializeVideo(video.source).then((_) {
    //     isPlaying = true;
    //     // setState(() {
    //     //   if (widget.isInView) {
    //     //     controller?.play();
    //     //   }
    //     // });
    //   });
    // }
    // if (!widget.isInView) {
    //   videoIsInitialized = false;
    // }

    Widget thumbnail = Container(
      decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          image: DecorationImage(
              image: AssetImage(video.thumbnail), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(15)),
    );

    return thumbnail;

    // SizedBox.expand(
    //   child: FittedBox(
    //     fit: BoxFit.cover,
    //     child: controller != null
    //         ? controller!.dataSource == video.source &&
    //                 controller!.value.isInitialized
    //             ? VideoPlayer(controller!)
    //             : thumbnail
    //         : thumbnail,
    //   ),
    // );
  }
}

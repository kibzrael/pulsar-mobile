import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/video.dart';
import 'package:pulsar/providers/video_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  bool isPaused = false;

  late Key visibilityKey;
  bool visible = false;

  @override
  void initState() {
    super.initState();
    visibilityKey = Key(DateTime.now().toString());
    video = widget.video;
  }

  @override
  void dispose() {
    // if (controller?.dataSource == video.source) {
    //   controller?.dispose();
    //   controller = null;
    // }
    super.dispose();
  }

  initVideo() {
    videoProvider.initializeVideo(video.source);
  }

  @override
  Widget build(BuildContext context) {
    videoProvider = Provider.of<VideoProvider>(context);
    controller = videoProvider.videoPlayerController;

    if (!videoIsInitialized && widget.isInView) {
      videoIsInitialized = true;

      videoProvider.initializeVideo(video.source).then((_) {
        setState(() {
          if (widget.isInView && visible) {
            controller = videoProvider.videoPlayerController;
            // check if app is in background
            controller?.play();
            isPlaying = true;
          }
        });
      });
    }
    if (!widget.isInView) {
      videoIsInitialized = false;
    }

    Widget thumbnail = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        image: DecorationImage(
            image: CachedNetworkImageProvider(video.thumbnail),
            fit: BoxFit.cover),
      ),
    );

    return InkWell(
      onTap: () {
        setState(() {
          if (isPlaying) {
            controller?.pause();
            isPlaying = false;
            isPaused = true;
          } else {
            controller?.play();
            isPlaying = true;
            isPaused = false;
          }
        });
      },
      child: VisibilityDetector(
        onVisibilityChanged: (info) {
          print(info.visibleFraction);
          if (info.visibleFraction < 0.5) {
            visible = false;
            if (controller != null) {
              if (video.source == controller!.dataSource) {
                isPlaying = false;
                controller?.pause();
              }
            }
          }
          if (info.visibleFraction > 0.5) {
            visible = true;
            if (controller != null && !isPlaying && !isPaused) {
              if (video.source == controller!.dataSource) {
                controller?.play();
                isPlaying = true;
              }
            }
          }
        },
        key: visibilityKey,
        child: Stack(
          children: [
            controller != null
                ? controller!.dataSource == video.source &&
                        controller!.value.isInitialized
                    ? SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                              width: controller?.value.size.width ?? 0,
                              height: controller?.value.size.height ?? 0,
                              child: VideoPlayer(controller!)),
                        ),
                      )
                    : thumbnail
                : thumbnail,
            PausePlay(isPaused)
          ],
        ),
      ),
    );
  }
}

class PausePlay extends StatelessWidget {
  final bool paused;

  PausePlay(this.paused);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: paused
          ? Icon(
              MyIcons.play,
              size: 150,
            )
          : Container(),
    );
  }
}

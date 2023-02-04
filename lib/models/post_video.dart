import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/providers/video_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostVideo extends StatefulWidget {
  final Video video;
  final Photo thumbnail;
  final String? filter;

  final bool isInView;

  const PostVideo(this.video, this.thumbnail,
      {Key? key, this.filter, this.isInView = false})
      : super(key: key);

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  late Video video;
  late VideoProvider videoProvider;

  VideoPlayerController? controller;

  bool videoIsInitialized = false;
  bool isPlaying = false;

  bool get controllerPlaying {
    if (controller == null) return false;
    return controller!.value.isPlaying;
  }

  bool isPaused = false;

  late Key visibilityKey;
  bool visible = false;

  String videoPath = '';

  @override
  void initState() {
    super.initState();
    visibilityKey = Key(DateTime.now().toString());
    video = widget.video;
  }

  @override
  void dispose() {
    if (controller?.dataSource == videoPath) {
      controller?.pause();
      // controller?.dispose();
      // controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    videoProvider = Provider.of<VideoProvider>(context);
    controller = videoProvider.videoPlayerController;

    if (!videoIsInitialized && widget.isInView) {
      videoIsInitialized = true;

      videoProvider.initializeVideo(video.video(context)).then((_) {
        setState(() {
          if (widget.isInView && visible) {
            videoPath == video.video(context);
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
        image: DecorationImage(
            image: CachedNetworkImageProvider(widget.thumbnail.photo(context)),
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
          if (info.visibleFraction < 0.5) {
            visible = false;
            if (controller != null) {
              if (video.video(context) == controller!.dataSource) {
                isPlaying = false;
                try {
                  controller?.pause();
                } catch (e) {
                  debugPrintStack();
                }
              }
            }
          } else {
            visible = true;
            if (controller != null && !isPlaying && !isPaused) {
              if (video.video(context) == controller!.dataSource) {
                try {
                  controller?.play();
                } catch (e) {
                  debugPrintStack();
                }
                isPlaying = true;
              }
            }
          }
        },
        key: visibilityKey,
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter:
                  ColorFilter.matrix(getFilter(widget.filter).convolution),
              child: controller != null
                  ? controller!.dataSource == video.video(context) &&
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
            ),
            if (!controllerPlaying && !isPlaying && !isPaused)
              const Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(height: 2, child: LinearProgressIndicator())),
            Positioned.fill(
                child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.black12,
                Colors.transparent,
                Colors.transparent,
                Colors.black26
              ], stops: [
                0,
                0.3,
                0.6,
                1
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            )),
            PausePlay(isPaused)
          ],
        ),
      ),
    );
  }
}

class PausePlay extends StatelessWidget {
  final bool paused;

  const PausePlay(this.paused, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: paused
          ? Icon(
              MyIcons.play,
              size: 100,
            )
          : Container(),
    );
  }
}

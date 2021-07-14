import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
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

// class _PostVideoState extends State<PostVideo> {
//   late Video video;
//   late VideoProvider videoProvider;

//   VideoPlayerController? controller;

//   bool videoIsInitialized = false;
//   bool isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     video = widget.video;
//     controller = VideoPlayerController.network(video.source);
//     controller!.initialize().then((value) {
//       setState(() {});
//     });
//     if (widget.isInView) {
//       controller?.play();
//       controller?.setLooping(true);
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   initVideo() {
//     videoProvider.initializeVideo(video.source);
//   }

//   @override
//   Widget build(BuildContext context) {
//     videoProvider = Provider.of<VideoProvider>(context);
//     controller = videoProvider.videoPlayerController;

//     if (!videoIsInitialized && widget.isInView) {
//       videoIsInitialized = true;

//       videoProvider.initializeVideo(video.source).then((_) {
//         isPlaying = true;
//         setState(() {
//           controller?.play();
//           // if (widget.isInView) {
//           //   controller?.play();
//           // }
//         });
//       });
//     }
//     if (!widget.isInView) {
//       videoIsInitialized = false;
//     }

//     Widget thumbnail = Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).inputDecorationTheme.fillColor,
//         image: DecorationImage(
//             image: AssetImage(video.thumbnail), fit: BoxFit.cover),
//         // borderRadius: BorderRadius.circular(15)
//       ),
//       child: Center(
//         child: Text('isPlaying: $isPlaying \ninView : ${widget.isInView}'),
//       ),
//     );

//     // return thumbnail;

//     return controller != null
//         ? controller!.dataSource == video.source &&
//                 controller!.value.isInitialized
//             ? SizedBox.expand(
//                 child: FittedBox(
//                   fit: BoxFit.cover,
//                   child: SizedBox(
//                       width: controller?.value.size.width ?? 0,
//                       height: controller?.value.size.height ?? 0,
//                       child: VideoPlayer(controller!)),
//                 ),
//               )
//             : thumbnail
//         : thumbnail;
//   }
// }

class _PostVideoState extends State<PostVideo> {
  late Video video;
  late VideoProvider videoProvider;

  VideoPlayerController? controller;

  bool videoIsInitialized = false;
  bool isPlaying = false;

  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    video = widget.video;
  }

  @override
  void dispose() {
    // controller?.dispose();
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
          if (widget.isInView) {
            controller = videoProvider.videoPlayerController;
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
            image: AssetImage(video.thumbnail), fit: BoxFit.cover),
      ),
    );

    // return thumbnail;

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
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text('isPlaying: $isPlaying '),
          //       Text('inView : ${widget.isInView}'),
          //       Text(
          //           'controllerPlaying : ${controller == null ? 'null' : controller!.value.isPlaying}'),
          //       Text(
          //           'controllerInitialized : ${controller == null ? 'null' : controller!.value.isInitialized}'),
          //       Text(
          //           'controllersource : ${controller == null ? 'null' : controller!.dataSource}'),
          //     ],
          //   ),
          // ),
          PausePlay(isPaused)
        ],
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

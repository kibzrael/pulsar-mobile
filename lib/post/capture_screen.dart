import 'dart:io';
import 'dart:typed_data';

// import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/post/edit_screen.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/post/trimmer.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/loading_dialog.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;
import 'package:video_trimmer/video_trimmer.dart' as video_trimmer;

class CaptureScreen extends StatefulWidget {
  final VideoCapture video;
  final double duration;
  const CaptureScreen(this.video, {Key? key, required this.duration})
      : super(key: key);
  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  late PostProvider provider;

  late VideoCapture video;

  late VideoPlayerController controller;

  double get speed => video.speed;

  // double get max => 90 * video.speed;
  int maxDuration = 90000;

  List<Uint8List?> thumbnails = [];

  double position = 0.0;
  double duration = 3000.0;

  int trimStart = 0;
  int trimEnd = 3000;

  @override
  void initState() {
    super.initState();
    video = widget.video;
    duration = widget.duration;
    _ticker = createTicker((elapsed) {
      position = controller.value.position.inMilliseconds.toDouble();

      if ((position >= (trimEnd * speed)) || (position < (trimStart * speed))) {
        controller.seekTo(Duration(milliseconds: (trimStart * speed).floor()));
      }
      if (position < trimStart * speed) {
      } else {
        setState(() {});
      }
    });

    controller = VideoPlayerController.file(video.video);
    controller.initialize().then((value) {
      controller.setLooping(true);
      trimEnd = controller.value.duration.inMilliseconds > maxDuration
          ? maxDuration
          : controller.value.duration.inMilliseconds;
      duration = controller.value.duration.inMilliseconds.toDouble();
      controller.play();
      _ticker.start();
      maxDuration = duration < 90000 ? duration.floor() : 90000;
      getThumbnails();
    });
  }

  getThumbnails() async {
    // double max = maxDuration > duration ? duration : maxDuration.toDouble();
    int stepSize = maxDuration ~/ 9;
    for (int step = 0; step < duration / stepSize; step++) {
      int position = stepSize * step;
      Uint8List? thumbnail = await thumb.VideoThumbnail.thumbnailData(
          video: video.video.path, timeMs: position);

      // await VideoCompress.getByteThumbnail(video.video.path,
      //     position: position * 1000);
      thumbnails.add(thumbnail);
    }
  }

  String state = 'none';

  Future<void> trim() async {
    state = 'initial';
    Permission storage = Permission.storage;
    Permission manageStorage = Permission.manageExternalStorage;
    if (!await storage.isGranted) {
      await storage.request();
      // if (status != PermissionStatus.granted) Navigator.pop(context);
    }
    if (!await manageStorage.isGranted) {
      await manageStorage.request();
      // if (status != PermissionStatus.granted) Navigator.pop(context);
    }

    video_trimmer.Trimmer trimmer = video_trimmer.Trimmer();

    await trimmer.loadVideo(videoFile: video.video.absolute);

    await trimmer.saveTrimmedVideo(
        startValue: trimStart.toDouble(),
        endValue: trimEnd.toDouble(),
        onSave: (path) {
          setState(() {
            state = path ?? 'Failed';
            if (path != null) {
              video.video = File(path);
            }
          });
        });
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  void dispose() {
    _ticker.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<PostProvider>(context);

    int rotate = provider.rotate;
    return Theme(
      data: darkTheme.copyWith(scaffoldBackgroundColor: Colors.black),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                openDialog(
                        context,
                        (context) => const MyDialog(
                              title: 'Caution!',
                              body:
                                  'The selected video and changes you\'ve made would be lost if you quit.',
                              actions: ['Cancel', 'Ok'],
                              destructive: 'Ok',
                            ),
                        dismissible: true)
                    .then((value) {
                  if (value == 'Ok') Navigator.pop(context);
                });
              },
              icon: Icon(
                MyIcons.close,
                size: 30,
              )),
          actions: [
            Container(
              width: 100,
              alignment: Alignment.center,
              child: ActionButton(
                  title: 'Next',
                  width: 70,
                  height: 30,
                  onPressed: () async {
                    provider.video = video;
                    // trim();
                    await openDialog(
                        context,
                        (context) =>
                            Theme(data: darkTheme, child: LoadingDialog(trim)));
                    Navigator.of(context).push(
                        myPageRoute(builder: (context) => EditScreen(video)));
                  }),
            )
          ],
        ),
        body: InkWell(
          onTap: () {
            controller.play();
          },
          child: Stack(
            children: [
              controller.value.isInitialized
                  ? SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: kToolbarHeight),
                        child: FittedBox(
                          fit: video.camera && (rotate == 0 || rotate == 180)
                              ? BoxFit.cover
                              : BoxFit.contain,
                          child: RotatedBox(
                            quarterTurns: rotate ~/ 90,
                            // angle: rotate.toDouble() * -math.pi / 180,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: ColorFiltered(
                                  colorFilter: ColorFilter.matrix(
                                      provider.filter.convolution),
                                  child: VideoPlayer(controller)),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                color: Colors.black12,
                child: Column(
                  children: [
                    const Spacer(),
                    Text(state),
                    Trimmer(
                      position: position,
                      duration: duration,
                      speed: speed,
                      max: maxDuration,
                      onUpdate: (start, end) {
                        setState(() {
                          trimStart = start.floor();
                          trimEnd = end.floor();
                        });
                      },
                      thumbnails: thumbnails,
                      provider: provider,
                    ),
                    Container(
                      height: kToolbarHeight,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: InkWell(
                        onTap: () {
                          if (provider.rotate < 270) {
                            provider.rotate += 90;
                          } else {
                            provider.rotate = 0;
                          }
                          provider.notify();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(MyIcons.rotate),
                            ),
                            const Text(
                              'Rotate',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

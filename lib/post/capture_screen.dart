import 'dart:io';
import 'dart:typed_data';

// import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/post/edit_screen.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/post/trimmer.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/loading_dialog.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/text_button.dart';
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class CaptureScreen extends StatefulWidget {
  final VideoCapture video;
  final double duration;
  const CaptureScreen(this.video, {Key? key, required this.duration})
      : super(key: key);
  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  late PostProvider provider;

  late VideoCapture video;

  late VideoCapture trimmedVideo;

  late VideoPlayerController controller;

  double get speed => video.speed;

  // double get max => 90 * video.speed;
  int maxDuration = 90000;

  List<Uint8List?> get thumbnails => provider.thumbnails;

  double position = 0.0;
  double duration = 3000.0;

  int trimStart = 0;
  int trimEnd = 3000;
  int initialEnd = 3000;

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
      initialEnd = trimEnd;
      duration = controller.value.duration.inMilliseconds.toDouble();
      controller.play();
      _ticker.start();
      maxDuration = duration < 90000 ? duration.floor() : 90000;
    });
  }

  String state = 'none';

  Future<void> trim(BuildContext dialogContext) async {
    // If not changed
    if (provider.rotate == 0 && trimStart == 0 && trimEnd == initialEnd) {
      Navigator.pop(dialogContext);
      await Future.delayed(const Duration(milliseconds: 300)).then((_) {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => EditScreen(video)));
      });

      return;
    }

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

    Duration startPoint = Duration(milliseconds: trimStart);
    Duration endPoint = Duration(milliseconds: trimEnd);

    Directory tempDirectory = await getTemporaryDirectory();
    String now = DateTime.now().toString().replaceAll(' ', '');
    String outputPath = '${tempDirectory.absolute.path}/Video$now.mp4';

    String command =
        ' -ss $startPoint -i "${video.video.absolute.path}" -t ${endPoint - startPoint} ';

    command += provider.rotate == 0
        ? ''
        : provider.rotate == 90
            ? '-vf "transpose=1" '
            : provider.rotate == 180
                ? '-vf "transpose=2,transpose=2" '
                : provider.rotate == 270
                    ? '-vf "transpose=2" '
                    : '';
    command += outputPath;

    try {
      await FFmpegKit.executeAsync(command, (FFmpegSession session) async {
        String state =
            FFmpegKitConfig.sessionStateToString(await session.getState());
        ReturnCode? returnCode = await session.getReturnCode().then((code) {
          Navigator.pop(dialogContext);
          return code;
        });
        debugPrint(
            "FFmpeg process exited with state $state and rc $returnCode");

        if (ReturnCode.isSuccess(returnCode)) {
          setState(() {
            trimmedVideo = VideoCapture(File(outputPath), camera: video.camera);
          });
          // Fluttertoast.showToast(msg: outputPath);
          if (await trimmedVideo.video.length() > 2000000) {
            provider.compress();
          } else {
            provider.getThumbnails((endPoint - startPoint).inMilliseconds);
          }
          await Future.delayed(const Duration(milliseconds: 300)).then((_) {
            Navigator.of(context).push(
                myPageRoute(builder: (context) => EditScreen(trimmedVideo)));
          });
        } else {
          Fluttertoast.showToast(msg: "Error");
        }
      }, (Log log) {
        debugPrint("Capture Screen:${log.getMessage()}");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
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
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text("Trim"),
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
            child: MyTextButton(
                text: 'Next',
                onPressed: () async {
                  provider.video = video;
                  // trim();
                  await openDialog(
                      context, (context) => LoadingDialog(trim, pop: false));
                }),
          )
        ],
      ),
      body: InkWell(
        onTap: () {
          controller.play();
        },
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: Stack(
            children: [
              controller.value.isInitialized
                  ? SizedBox.expand(
                      child: FittedBox(
                        fit:
                            // video.camera && (rotate == 0 || rotate == 180)
                            //     ? BoxFit.cover
                            //     :
                            BoxFit.contain,
                        child: RotatedBox(
                          quarterTurns: rotate ~/ 90,
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
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
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
            ),
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
          ],
        ),
      ),
    );
  }
}

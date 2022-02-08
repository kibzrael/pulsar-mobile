import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/post/audio/audio.dart';
import 'package:pulsar/post/camera_view.dart';
import 'package:pulsar/post/capture_button.dart';
import 'package:pulsar/post/capture_screen.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/post/timer.dart';
import 'package:pulsar/providers/camera_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/transitions.dart';

class CameraScreen extends StatefulWidget {
  final Function onPop;
  CameraScreen({required this.onPop});
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  late final Ticker _ticker;

  late CameraProvider provider;

  bool get isRecording => provider.controller?.value.isRecordingVideo ?? false;

  double speed = 1;

  double get max => timer * speed;

  RecordingDurationNotifier recordingDurationNotifier =
      RecordingDurationNotifier();

  double cameraPreviewScale = 1;
  double cameraSecondaryScale = 1;

  late AnimationController _switchAnimationController;

  Widget? overlay;

  bool showTimer = true;

  int timer = 60;

  CameraScreenPermissions? permissions;

  @override
  void initState() {
    super.initState();
    _ticker = this.createTicker((elapsed) {
      recordingDurationNotifier.setDuration(elapsed.inMilliseconds.toDouble());
      checkPermissions();
    });
    _switchAnimationController = AnimationController(
        vsync: this, duration: Duration(seconds: 1), value: 0);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _switchAnimationController.dispose();
    super.dispose();
  }

  checkPermissions() async {
    permissions = CameraScreenPermissions(
      camera: await Permission.camera.status.isGranted,
      audio: await Permission.microphone.status.isGranted,
      storage: await Permission.storage.status.isGranted,
    );
  }

  onCapture() async {
    VideoSnapshot? snapshot = await provider.recordVideo();

    if (snapshot == null) return;

    if (snapshot.hasError)
      Fluttertoast.showToast(msg: '${snapshot.error!.description}');
    else
      _ticker.start();

    setState(() {});
  }

  stopRecording({required double duration}) async {
    if (!isRecording) return;
    VideoSnapshot? snapshot = await provider.stopVideoRecording();
    if (snapshot == null) {
      Fluttertoast.showToast(msg: '$snapshot');
      return;
    }
    if (snapshot.hasError)
      Fluttertoast.showToast(msg: '${snapshot.error!.description}');

    if (snapshot.video != null) {
      _ticker.stop();
      setState(() {});
      Navigator.of(context).push(myPageRoute(
          builder: (context) => CaptureScreen(
              VideoCapture(File(snapshot.video!.path), camera: true),
              duration: duration)
          // EditScreen(VideoCapture(
          //       File(snapshot.video!.path),
          //       camera: true,
          //     )
          //     )
          ));
    }
  }

  setTimer(int time) {
    timer = time;
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CameraProvider>(context);

    PostProvider postProvider = Provider.of<PostProvider>(context);

    Widget captureButton() {
      return ValueListenableBuilder(
        valueListenable: recordingDurationNotifier.notifier,
        builder: (context, double duration, child) {
          if ((duration / 1000) >= max && isRecording) {
            stopRecording(duration: duration);
          }
          return CaptureButton(
            isRecording: isRecording,
            onPressed: () {
              if (provider.controller != null) {
                if (isRecording)
                  stopRecording(duration: duration);
                else
                  onCapture();
              }
            },
            position: duration,
            max: max * 1000,
          );
        },
      );
    }

    Widget recordingOverlay() {
      return Align(alignment: Alignment.bottomCenter, child: captureButton());
    }

    // setSpeed(int index) {
    //   setState(() {
    //     speed = speeds[index] ?? 1;
    //   });
    // }

    return Theme(
      data: darkTheme.copyWith(scaffoldBackgroundColor: Colors.black),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onScaleUpdate: ((touch) {
            double max = provider.maxZoom;
            setState(() {
              if ((cameraSecondaryScale * touch.scale) >= 1) {
                if ((cameraSecondaryScale * touch.scale) <= max) {
                  cameraPreviewScale = (cameraSecondaryScale * touch.scale);
                } else {
                  cameraPreviewScale = max;
                }
              } else {
                cameraPreviewScale = 1;
              }
              provider.controller!.setZoomLevel(cameraPreviewScale);
            });
          }),
          onScaleEnd: (_) {
            setState(() {
              cameraSecondaryScale = cameraPreviewScale;
            });
          },
          child: Stack(
            children: [
              ColorFiltered(
                  colorFilter:
                      ColorFilter.matrix(postProvider.filter.convolution),
                  child: CameraView(provider)),
              Positioned.fill(
                bottom: kToolbarHeight,
                child: ScaledTransition(
                  reverse: overlay == null,
                  child: isRecording
                      ? recordingOverlay()
                      : overlay != null
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: overlay!)
                          : Container(
                              child: Column(
                                children: [
                                  AppBar(
                                    backgroundColor: Colors.transparent,
                                    leading: IconButton(
                                      icon: Icon(
                                        MyIcons.back,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        if (provider.controller != null) {
                                          if (!isRecording) {
                                            widget.onPop();
                                          }
                                        } else {
                                          widget.onPop();
                                        }
                                      },
                                    ),
                                    actions: [
                                      Container(
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: RotationTransition(
                                          alignment: Alignment.center,
                                          turns:
                                              _switchAnimationController.view,
                                          child: IconButton(
                                            icon: Icon(
                                              MyIcons.switchCamera,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              if (provider.flash)
                                                provider.switchFlash();
                                              provider.switchLens();
                                              cameraPreviewScale = 1;
                                              cameraSecondaryScale = 1;
                                              double value =
                                                  _switchAnimationController
                                                              .value ==
                                                          0
                                                      ? 0.5
                                                      : 0;
                                              _switchAnimationController
                                                  .animateTo(value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 100,
                                      child: Column(children: [
                                        InkWell(
                                          onTap: () {
                                            provider.switchFlash();
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  provider.flash
                                                      ? MyIcons.flash
                                                      : MyIcons.flashOff,
                                                  size: 30,
                                                ),
                                              ),
                                              Text('Flash'),
                                              Text(provider.flash
                                                  ? 'on'
                                                  : 'off'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              showTimer = !showTimer;
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  MyIcons.timer,
                                                  size: 30,
                                                ),
                                              ),
                                              Text('Timer'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        InkWell(
                                          onTap: () {
                                            openBottomSheet(
                                                context,
                                                (context) =>
                                                    Filters(postProvider));
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  MyIcons.filters,
                                                  size: 30,
                                                ),
                                              ),
                                              Text('Filters'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        InkWell(
                                          onTap: () {
                                            openBottomSheet(context,
                                                (context) => PostAudio(),
                                                root: false);
                                          },
                                          child: Column(
                                            children: [
                                              if (postProvider.audio != null)
                                                Container(
                                                  width: 42,
                                                  height: 42,
                                                  margin: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          postProvider.audio!
                                                              .coverPhoto),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              if (postProvider.audio == null)
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    MyIcons.music,
                                                    size: 30,
                                                  ),
                                                ),
                                              Text('Sounds'),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 150,
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // if (showTimer && !showFilters)
                                        //   CaptureTimer(
                                        //       initial: speed,
                                        //       onPressed: setTimer),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                XFile? pickedFile =
                                                    await ImagePicker()
                                                        .pickVideo(
                                                            source: ImageSource
                                                                .gallery);
                                                File? file;
                                                if (pickedFile != null)
                                                  file = File(pickedFile.path);
                                                if (file != null) {
                                                  VideoData? data =
                                                      await FlutterVideoInfo()
                                                          .getVideoInfo(
                                                              file.path);
                                                  Navigator.of(context).push(
                                                      myPageRoute(
                                                          builder: (context) =>
                                                              CaptureScreen(
                                                                VideoCapture(
                                                                    file!,
                                                                    camera:
                                                                        false),
                                                                duration:
                                                                    data?.duration ??
                                                                        3000,
                                                              )));
                                                }
                                                // openBottomSheet(context,
                                                //     (context) => Gallery(),
                                                //     root: false);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .dividerColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/dance.jpg'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Text(
                                                      'Upload',
                                                      style: TextStyle(
                                                          fontSize: 16.5,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            captureButton(),
                                            Container(
                                              width: 60,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: kToolbarHeight,
                    child: isRecording
                        ? null
                        : CaptureTimer(initial: speed, onPressed: setTimer)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RecordingDurationNotifier {
  ValueNotifier<double> notifier = ValueNotifier<double>(0.0);

  setDuration(double duration) {
    notifier.value = duration;
  }
}

class CameraScreenPermissions {
  bool camera;
  bool audio;
  bool storage;

  bool get error => !camera || !audio || !storage;

  CameraScreenPermissions(
      {required this.camera, required this.audio, required this.storage});
}

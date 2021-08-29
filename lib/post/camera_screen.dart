import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/post/audio/audio.dart';
import 'package:pulsar/post/camera_view.dart';
import 'package:pulsar/post/capture_button.dart';
import 'package:pulsar/post/edit_screen.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/post/gallery.dart';
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
  bool showFilters = false;

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

  stopRecording() async {
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
          builder: (context) => EditScreen(VideoCapture(
                File(snapshot.video!.path),
                camera: true,
              ))));
    }
  }

  setTimer(int time) {
    timer = time;
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CameraProvider>(context);

    PostProvider postProvider = Provider.of<PostProvider>(context);

    // trial kibzrael contribution

    Widget captureButton() {
      return ValueListenableBuilder(
        valueListenable: recordingDurationNotifier.notifier,
        builder: (context, double duration, child) {
          if ((duration / 1000) >= max && isRecording) {
            stopRecording();
          }
          return CaptureButton(
            isRecording: isRecording,
            onPressed: () {
              if (provider.controller != null) {
                if (isRecording)
                  stopRecording();
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
      data: darkTheme,
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
              CameraView(provider),
              Positioned.fill(
                bottom: kToolbarHeight,
                child: ScaledTransition(
                  reverse: overlay == null,
                  child: isRecording
                      ? recordingOverlay()
                      : overlay != null
                          ? overlay!
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
                                            setState(() {
                                              showFilters = !showFilters;
                                            });
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
                                            setState(() {
                                              overlay = PostAudio(pop: () {
                                                setState(() {
                                                  overlay = null;
                                                });
                                              });
                                            });
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
                                                      image: AssetImage(
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
                                              Text('Audio'),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                  Spacer(),
                                  ScaledTransition(
                                    child: showFilters
                                        ? Filters()
                                        : Container(
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        openBottomSheet(
                                                            context,
                                                            (context) =>
                                                                Gallery(),
                                                            root: false);
                                                      },
                                                      child: Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .dividerColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/old_logo.jpg'),
                                                                fit: BoxFit
                                                                    .cover),
                                                            border: Border.all(
                                                                width: 2,
                                                                color: Colors
                                                                    .white)),
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
                                    reverse: !showFilters,
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

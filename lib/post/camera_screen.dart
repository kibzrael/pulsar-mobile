import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/post/capture_speed.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/post/gallery.dart';
import 'package:pulsar/providers/camera_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/post/capture_screen.dart';

class CameraScreen extends StatefulWidget {
  final Function onPop;
  CameraScreen({required this.onPop});
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraProvider provider;

  onCapture() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => CaptureScreen()));
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CameraProvider>(context);
    return Theme(
      data: darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              MyIcons.back,
              size: 30,
            ),
            onPressed: () {
              widget.onPop();
            },
          ),
          actions: [
            Container(
              width: 100,
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  MyIcons.switchCamera,
                  size: 30,
                ),
                onPressed: () {
                  provider.switchLens();
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            CameraView(provider),
            Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 100,
                      child: Column(children: [
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  MyIcons.flashlight,
                                  size: 30,
                                ),
                              ),
                              Text('Flash'),
                              Text('on'),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            openBottomSheet(
                                context, (context) => CaptureSpeed());
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  MyIcons.speed,
                                  size: 30,
                                ),
                              ),
                              Text('Speed'),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            openBottomSheet(context, (context) => Filters());
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
                      ]),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              myPageRoute(builder: (context) => Gallery()));
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: AssetImage('assets/users/melissa.jpg'),
                                  fit: BoxFit.cover),
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                        ),
                      ),
                      InkWell(
                        onTap: onCapture,
                        child: Container(
                          margin: EdgeInsets.all(12),
                          constraints:
                              BoxConstraints(maxHeight: 100, maxWidth: 100),
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 3)),
                          child: AnimatedContainer(
                              margin: EdgeInsets.all(6),
                              padding: EdgeInsets.all(12),
                              duration: Duration(milliseconds: 700),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                MyIcons.camera,
                                color: Colors.white,
                                size: 35,
                              )),
                        ),
                      ),
                      Container(
                        width: 60,
                      ),
                    ],
                  ),
                  SizedBox(height: kToolbarHeight + 12)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  final CameraProvider provider;
  CameraView(this.provider);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraProvider provider;
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    provider = widget.provider;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      initCamera();
    });
  }

  initCamera() {
    provider.initialize().then((value) {
      if (mounted) {
        setState(() {
          controller = provider.controller;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    provider.disposeCamera();
  }

  @override
  Widget build(BuildContext context) {
    controller = provider.controller;
    return Padding(
      padding: EdgeInsets.only(
        bottom: kToolbarHeight,
        top: 36,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: darkTheme.inputDecorationTheme.fillColor,
          child: controller != null
              ? controller!.value.isInitialized
                  ? CameraPreview(controller!)
                  : Container()
              : Container(),
        ),
      ),
    );
  }
}

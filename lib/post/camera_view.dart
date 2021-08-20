import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/providers/camera_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';

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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration:
              BoxDecoration(color: darkTheme.inputDecorationTheme.fillColor),
          foregroundDecoration: BoxDecoration(color: Colors.black12),
          child: controller != null
              ? controller!.value.isInitialized
                  ? SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width *
                              controller!.value.aspectRatio,
                          child: CameraPreview(
                            controller!,
                          ),
                        ),
                      ),
                    )
                  // CameraPreview(controller!)
                  : Container()
              : Container(),
        ),
      ),
    );
  }
}

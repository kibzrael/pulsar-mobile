import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/post/edit_screen.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/post/trim.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:video_player/video_player.dart';

class CaptureScreen extends StatefulWidget {
  final VideoCapture video;
  CaptureScreen(this.video);
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

  double get max => 90 * video.speed;
  int get maxMilli => (max * 10000).floor();

  double position = 0.0;
  double duration = 3000.0;

  int trimStart = 0;
  int trimEnd = 3000;

  @override
  void initState() {
    super.initState();
    video = widget.video;
    _ticker = this.createTicker((elapsed) {
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
      controller.play();
      trimEnd = controller.value.duration.inMilliseconds > maxMilli
          ? maxMilli
          : controller.value.duration.inMilliseconds;
      duration = controller.value.duration.inMilliseconds.toDouble();
      _ticker.start();
      controller.setLooping(true);
      setState(() {});
    }).catchError((_) {});
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
                onPressed: () {
                  provider.video = video;
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
        child: Padding(
          padding: EdgeInsets.only(bottom: kToolbarHeight),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              child: Stack(
                children: [
                  controller.value.isInitialized
                      ? SizedBox.expand(
                          child: FittedBox(
                            fit: video.camera ? BoxFit.cover : BoxFit.contain,
                            child: SizedBox(
                                width: controller.value.size.width,
                                height: controller.value.size.height,
                                child: VideoPlayer(controller)),
                          ),
                        )
                      : Container(),
                  Container(
                    color: Colors.black12,
                    child: Column(
                      children: [
                        Spacer(),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 30),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       Text('$trimStart'),
                        //       Text('$trimEnd'),
                        //     ],
                        //   ),
                        // ),
                        TrimVideo(
                          position: position,
                          duration: duration,
                          speed: speed,
                          onUpdate: (start, end) {
                            setState(() {
                              trimStart = start.floor();
                              trimEnd = end.floor();
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

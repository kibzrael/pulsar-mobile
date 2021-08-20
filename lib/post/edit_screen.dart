import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/models/post_video.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/post/upload_screen.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:video_player/video_player.dart';

class EditScreen extends StatefulWidget {
  final VideoCapture video;
  EditScreen(this.video);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late VideoPlayerController controller;

  late VideoCapture video;

  late PostProvider provider;

  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    video = widget.video;
    controller = VideoPlayerController.file(widget.video.video);

    controller.initialize().then((value) {
      controller.setPlaybackSpeed(video.speed);
      controller.play();
      controller.setLooping(true);
      setState(() {});
    }).catchError((_) {});
  }

  @override
  void dispose() {
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
                  Navigator.of(context).push(myPageRoute(
                      builder: (context) => UploadScreen(
                            caption: provider.caption,
                          )));
                }),
          )
        ],
      ),
      body: InkWell(
        onTap: () {
          setState(() {
            if (controller.value.isPlaying) {
              controller.pause();
              isPaused = true;
            } else {
              controller.play();
              isPaused = false;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: kToolbarHeight),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Theme.of(context).cardColor,
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
                    child: SafeArea(
                      child: Column(
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
                                          MyIcons.trim,
                                          size: 30,
                                        ),
                                      ),
                                      Text('Trim'),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                InkWell(
                                  onTap: () {
                                    openBottomSheet(
                                        context, (context) => Filters());
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
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          MyIcons.thumbnail,
                                          size: 30,
                                        ),
                                      ),
                                      Text('Cover'),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: [
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
                        ],
                      ),
                    ),
                  ),
                  PausePlay(isPaused),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

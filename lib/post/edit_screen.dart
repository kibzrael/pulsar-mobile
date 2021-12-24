import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/models/post_video.dart';
import 'package:pulsar/post/audio/audio.dart';
import 'package:pulsar/post/cover.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/post/upload_screen.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/transitions.dart';
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

  bool showFilters = false;

  Widget? overlay;

  double duration = 3000;

  @override
  void initState() {
    super.initState();
    video = widget.video;
    controller = VideoPlayerController.file(widget.video.video);

    controller.initialize().then((value) {
      duration = controller.value.duration.inMilliseconds.toDouble();
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

    PostProvider postProvider = Provider.of<PostProvider>(context);

    Widget editLabel(String text) {
      return Text(text,
          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500));
    }

    return Theme(
      data: darkTheme.copyWith(scaffoldBackgroundColor: Colors.black),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: InkWell(
          onTap: () {
            if (overlay == null)
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
          child: Stack(
            children: [
              controller.value.isInitialized
                  ? SizedBox.expand(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: kToolbarHeight),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            child: FittedBox(
                              fit: video.camera ? BoxFit.cover : BoxFit.contain,
                              child: SizedBox(
                                  width: controller.value.size.width,
                                  height: controller.value.size.height,
                                  child: VideoPlayer(controller)),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: overlay == null ? 1 : 0,
                  child: PausePlay(isPaused)),
              Container(
                color: Colors.black12,
                child: ScaledTransition(
                  reverse: overlay == null,
                  child: overlay != null
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: overlay!)
                      : Column(
                          children: [
                            AppBar(
                              backgroundColor: Colors.transparent,
                              leading: IconButton(
                                  onPressed: () {
                                    openDialog(
                                            context,
                                            (context) => MyDialog(
                                                  title: 'Caution!',
                                                  body:
                                                      'The changes you\'ve made would be lost if you quit.',
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
                                      onPressed: () {
                                        provider.video = video;
                                        provider.thumbnail.thumbnail =
                                            Uint8List(9);
                                        Navigator.of(context).push(myPageRoute(
                                            builder: (context) => UploadScreen(
                                                  caption: provider.caption,
                                                )));
                                      }),
                                )
                              ],
                            ),
                            Spacer(),
                            ScaledTransition(
                                reverse: !showFilters,
                                child: showFilters ? Filters() : Container()),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 21),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
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
                                                  BorderRadius.circular(6),
                                              image: DecorationImage(
                                                image: AssetImage(postProvider
                                                    .audio!.coverPhoto),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        if (postProvider.audio == null)
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              MyIcons.music,
                                              size: 36,
                                            ),
                                          ),
                                        editLabel('Sounds'),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            MyIcons.mic,
                                            size: 36,
                                          ),
                                        ),
                                        editLabel('Voiceover'),
                                      ],
                                    ),
                                  ),
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
                                            size: 36,
                                          ),
                                        ),
                                        editLabel('Filters'),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        overlay = PostCover(
                                            duration: duration,
                                            pop: () {
                                              setState(() {
                                                overlay = null;
                                              });
                                            });
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            MyIcons.thumbnail,
                                            size: 36,
                                          ),
                                        ),
                                        editLabel('Cover'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

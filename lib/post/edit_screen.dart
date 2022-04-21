import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/models/post_video.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/post/cover.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/post/upload_screen.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class EditScreen extends StatefulWidget {
  final VideoCapture video;
  const EditScreen(this.video, {Key? key}) : super(key: key);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late VideoPlayerController controller;

  late VideoCapture video;

  late PostProvider provider;

  bool isPaused = false;

  double duration = 3000;

  late Key visibilityKey;

  @override
  void initState() {
    super.initState();
    visibilityKey = Key(DateTime.now().toString());
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

    Widget editLabel(String text) {
      return Text(text,
          style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500));
    }

    return Theme(
      data: darkTheme.copyWith(scaffoldBackgroundColor: Colors.black),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          child: VisibilityDetector(
            key: visibilityKey,
            onVisibilityChanged: (info) {
              if (info.visibleFraction < 0.5) {
                if (controller.value.isInitialized) {
                  try {
                    controller.pause();
                    isPaused = true;
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                }
              }
              if (info.visibleFraction > 0.5) {
                if (controller.value.isInitialized) {
                  controller.play();
                  isPaused = false;
                }
              }
              if (mounted) {
                setState(() {});
              }
            },
            child: Stack(
              children: [
                controller.value.isInitialized
                    ? SizedBox.expand(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: kToolbarHeight),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: InkWell(
                              child: FittedBox(
                                fit: video.camera
                                    ? BoxFit.cover
                                    : BoxFit.contain,
                                child: SizedBox(
                                    width: controller.value.size.width,
                                    height: controller.value.size.height,
                                    child: ColorFiltered(
                                        colorFilter: ColorFilter.matrix(
                                            provider.filter.convolution),
                                        child: VideoPlayer(controller))),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                PausePlay(isPaused),
                Container(
                  color: Colors.black12,
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                            onPressed: () {
                              openDialog(
                                      context,
                                      (context) => Theme(
                                            data: darkTheme,
                                            child: const MyDialog(
                                              title: 'Caution!',
                                              body:
                                                  'The changes you\'ve made would be lost if you quit.',
                                              actions: ['Cancel', 'Ok'],
                                              destructive: 'Ok',
                                            ),
                                          ),
                                      dismissible: true)
                                  .then((value) {
                                if (value == 'Ok') {
                                  // reset values
                                  provider.filter = original;
                                  provider.thumbnail =
                                      VideoThumbnail(position: 0.0);
                                  //
                                  // reset audio to the one selected in camera
                                  //
                                  Navigator.pop(context);
                                }
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
                                  provider.aspectRatio =
                                      controller.value.aspectRatio;
                                  // TODO: initialize video editing
                                  Navigator.of(context).push(myPageRoute(
                                      builder: (context) => UploadScreen(
                                          caption: provider.caption)));
                                }),
                          )
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 21),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                // openBottomSheet(
                                //     context, (context) => const PostAudio(),
                                //     root: false);
                                toastNotImplemented();
                              },
                              child: Column(
                                children: [
                                  if (provider.audio != null)
                                    Container(
                                      width: 42,
                                      height: 42,
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                          image: NetworkImage(provider
                                              .audio!.coverPhoto.thumbnail),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  if (provider.audio == null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                // Navigator.of(context).push(myPageRoute(
                                //     builder: (context) => const Voiceover()));
                                toastNotImplemented();
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                openBottomSheet(
                                    context, (context) => Filters(provider));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                Navigator.of(context).push(myPageRoute(
                                    builder: (context) => PostCover(
                                        video: video, duration: duration)));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

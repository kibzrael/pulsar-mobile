import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class PostCover extends StatefulWidget {
  final VideoCapture video;
  final double duration;
  PostCover({required this.video, required this.duration});
  @override
  _PostCoverState createState() => _PostCoverState();
}

class _PostCoverState extends State<PostCover> {
  double cover = 18.0;

  double position = 0.0;

  late double maxWidth;

  late PostProvider postProvider;

  late VideoPlayerController controller;
  double duration = 3000;

  List<Uint8List?> thumbnails = [];

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
    position = postProvider.thumbnail.position;
    //
    controller = VideoPlayerController.file(widget.video.video);
    controller.initialize().then((value) {
      controller.seekTo(Duration(milliseconds: position.floor()));
      duration = controller.value.duration.inMilliseconds.toDouble();
      getThumbnails();
    });
  }

  getThumbnails() async {
    double maxDuration = duration * 1000;
    int stepSize = maxDuration ~/ 9;
    for (int step = 0; step < maxDuration / stepSize; step++) {
      int position = stepSize * step;
      Uint8List? thumbnail = await VideoCompress.getByteThumbnail(
          widget.video.video.path,
          position: position);
      setState(() {
        thumbnails.add(thumbnail);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // device width - (padding + right handle + cover widget)
    maxWidth = MediaQuery.of(context).size.width - (30 + 18 + 50);

    if (!isInitialized) cover = ((position / widget.duration) * maxWidth) + 18;

    isInitialized = true;
    position = ((cover - 18) / maxWidth) * widget.duration;

    controller.seekTo(Duration(milliseconds: position.floor()));

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Cover'),
          leading: IconButton(
            icon: Icon(MyIcons.close),
            onPressed: () {
              if (postProvider.thumbnail.position != position)
                openDialog(
                        context,
                        (context) => MyDialog(
                              title: 'Caution!',
                              body:
                                  'The selected cover and changes you\'ve made would be lost if you quit.',
                              actions: ['Cancel', 'Ok'],
                              destructive: 'Ok',
                            ),
                        dismissible: true)
                    .then((value) {
                  if (value == 'Ok') Navigator.pop(context);
                });
              else
                Navigator.pop(context);
            },
          ),
          actions: [
            MyTextButton(
                text: 'Done',
                onPressed: () {
                  postProvider.thumbnail = VideoThumbnail(position: position);
                  Navigator.pop(context);
                })
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Hero(
              tag: 'cover',
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                width: double.infinity,
                child: controller.value.isInitialized
                    ? FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: controller.value.size.width,
                          height: controller.value.size.height,
                          child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(
                                  postProvider.filter.convolution),
                              child: VideoPlayer(controller)),
                        ),
                      )
                    : null,
              ),
            )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            width: double.infinity,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                            ),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(
                                  postProvider.filter.convolution),
                              child: Row(
                                children: [
                                  for (Uint8List? thumbnail in thumbnails)
                                    Expanded(
                                        child: Container(
                                      height: 75,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white12, width: 1),
                                          image: thumbnail == null
                                              ? null
                                              : DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      MemoryImage(thumbnail))),
                                    ))
                                ],
                              ),
                            )),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 75,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(15))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(15)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 18,
                        height: 75,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(15))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(15)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: cover,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            if (cover + details.delta.dx < 18) {
                              cover = 18;
                            } else if (cover + details.delta.dx > maxWidth) {
                              cover = maxWidth;
                            } else {
                              cover += details.delta.dx;
                            }
                          });
                        },
                        child: Card(
                          elevation: 3,
                          margin: EdgeInsets.fromLTRB(0, 8, 2, 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            width: 50,
                            height: 85,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 5, color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 40,
                                height: 75,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                      width: controller.value.size.width,
                                      height: controller.value.size.height,
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.matrix(
                                              postProvider.filter.convolution),
                                          child: VideoPlayer(controller))),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ));
  }
}

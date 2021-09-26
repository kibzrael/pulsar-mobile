import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class PostCover extends StatefulWidget {
  final double duration;
  final Function() pop;
  PostCover({required this.duration, required this.pop});
  @override
  _PostCoverState createState() => _PostCoverState();
}

class _PostCoverState extends State<PostCover> {
  double cover = 18.0;

  double position = 0.0;

  late double maxWidth;

  late PostProvider postProvider;

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
    position = postProvider.thumbnail.position;
  }

  @override
  Widget build(BuildContext context) {
    // device width - (padding + right handle + cover widget)
    maxWidth = MediaQuery.of(context).size.width - (30 + 18 + 50);

    if (!isInitialized) cover = ((position / widget.duration) * maxWidth) + 18;

    isInitialized = true;
    position = ((cover - 18) / maxWidth) * widget.duration;

    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Cover'),
          leading: IconButton(
            icon: Icon(MyIcons.close),
            onPressed: () {
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
                if (value == 'Ok') widget.pop();
              });
            },
          ),
          actions: [
            MyTextButton(
                text: 'Done',
                onPressed: () {
                  postProvider.thumbnail = VideoThumbnail(position: position);
                  widget.pop();
                })
          ],
        ),
        Spacer(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
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
                            color: Colors.white12,
                          ),
                          child: ListView.builder(
                              itemCount: 15,
                              scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 25,
                                  height: 75,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white12, width: 1)),
                                );
                              }),
                        ),
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
                        child: Container(
                          width: 50,
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )),
      ],
    );
  }
}

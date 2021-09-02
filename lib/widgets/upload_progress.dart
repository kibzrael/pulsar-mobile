import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/functions/upload_post.dart';
import 'package:pulsar/secondary_pages.dart/upload_progress.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/text_button.dart';

class UploadProgress extends StatefulWidget {
  final UploadPost uploadPost;

  UploadProgress(this.uploadPost);

  @override
  _UploadProgressState createState() => _UploadProgressState();
}

class _UploadProgressState extends State<UploadProgress> {
  UploadPost get uploadPost => widget.uploadPost;

  double progress = 30;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Colors.transparent,
      closedElevation: 0.0,
      transitionDuration: Duration(milliseconds: 700),
      openBuilder: (context, action) => UploadProgressScreen(),
      closedBuilder: (context, open) {
        return InkWell(
          onTap: open,
          child: Container(
            height: kToolbarHeight,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                // border: Border(
                //   bottom: BorderSide(
                //       color: Theme.of(context).colorScheme.surface, width: 1),
                // ),
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: double.infinity,
                  margin: EdgeInsets.only(right: 7.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white12),
                  child: Center(
                      child: MyProgressIndicator(
                    size: 21,
                    margin: EdgeInsets.zero,
                  )),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '@${uploadPost.user.username}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).buttonColor
                        ]).createShader(bounds);
                      },
                      child: Text(
                        'Uploading...',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    )
                  ],
                )),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) {
                        return SweepGradient(
                            transform: GradientRotation(4.75),
                            stops: [
                              0.0, (progress / 100) * 0.5,
                              progress / 100,
                              progress / 100,
                              // 0.25,
                              // 0.5,
                              // 0.5
                            ],
                            colors: [
                              Colors.blue,
                              Colors.deepPurpleAccent,
                              Theme.of(context).accentColor,
                              Colors.white
                            ]).createShader(rect);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2)),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(2),
                        width: 24,
                        height: 21,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${progress.ceil()}%',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w800),
                          ),
                        ))
                  ],
                ),
                SizedBox(width: 5),
                MyTextButton(
                    text: 'Cancel',
                    onPressed: () {},
                    color: Theme.of(context).colorScheme.error)
                // InkWell(
                //     onTap: () {},
                //     child: Padding(
                //       padding: EdgeInsets.all(6.0),
                //       child: Icon(
                //         MyIcons.close,
                //         size: 30,
                //         color: Theme.of(context).colorScheme.error,
                //       ),
                //     ))
              ],
            ),
          ),
        );
      },
    );
  }
}

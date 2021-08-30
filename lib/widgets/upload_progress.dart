import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/upload_post.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

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
    return Container(
      height: kToolbarHeight,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.surface, width: 1),
        ),

        //     Border.symmetric(
        //         horizontal: BorderSide(
        //   color: Theme.of(context).dividerColor,
        //   width: 1,
        // ))
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: double.infinity,
            margin: EdgeInsets.only(right: 7.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).inputDecorationTheme.fillColor),
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
              Text(
                uploadPost.challenge?.name ??
                    uploadPost.user.category ??
                    'Personal Account',
                style: Theme.of(context).textTheme.subtitle2,
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
                    constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2)),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$progress%',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w800),
                      ),
                    )),
              ),
              //  Container(
              //       padding: EdgeInsets.all(2),
              //       width: 24,
              //       height: 24,
              //       alignment: Alignment.center,
              //       child: FittedBox(
              //         fit: BoxFit.scaleDown,
              //         child:Text(
              //                 '${((widget.max - widget.position) / 1000).ceil()}',
              //                 style: TextStyle(
              //                     fontSize: 21, fontWeight: FontWeight.w800),
              //               ),
              //       ))
            ],
          ),
          SizedBox(width: 5),
          InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  MyIcons.close,
                  size: 30,
                  color: Theme.of(context).colorScheme.error,
                ),
              ))
        ],
      ),
    );
  }
}

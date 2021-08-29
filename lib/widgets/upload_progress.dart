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
              Row(
                children: [
                  Text(
                    '@${uploadPost.user.username}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(width: 12),
                  ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                            begin: Alignment.centerLeft,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).buttonColor
                            ]).createShader(rect);
                      },
                      child: Text('Uploading...'))
                ],
              ),
              Text(
                uploadPost.challenge?.name ??
                    uploadPost.user.category ??
                    'Personal Account',
                style: Theme.of(context).textTheme.subtitle2,
              )
            ],
          )),
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).inputDecorationTheme.fillColor),
              child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(MyIcons.close),
                  )))
        ],
      ),
    );
  }
}

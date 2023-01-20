import 'package:flutter/material.dart';
import 'package:pulsar/functions/upload_post.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/text_button.dart';

class UploadProgress extends StatefulWidget {
  final UploadPost uploadPost;
  final bool barIsTransparent;

  const UploadProgress(this.uploadPost,
      {Key? key, this.barIsTransparent = false})
      : super(key: key);

  @override
  _UploadProgressState createState() => _UploadProgressState();
}

class _UploadProgressState extends State<UploadProgress> {
  UploadPost get uploadPost => widget.uploadPost;
  bool get barIsTransparent => widget.barIsTransparent;

  double get progress => widget.uploadPost.progress * 100;

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).brightness == Brightness.light;
    Color? textColor = barIsTransparent
        ? Colors.white
        : Theme.of(context).textTheme.bodyText2!.color;
    return Container(
      height: kToolbarHeight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: Theme.of(context)
                    .dividerColor
                    .withOpacity(themeIsLight ? 0.5 : 1),
                width: 1),
          ),
          gradient: barIsTransparent
              ? const LinearGradient(
                  colors: [Colors.transparent, Colors.black54, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              : null),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 7.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: barIsTransparent
                      ? Colors.white12
                      : Theme.of(context).inputDecorationTheme.fillColor,
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                      getFilter(uploadPost.filter).convolution),
                  child: Container(
                    width: 50,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(uploadPost.thumbnail))),
                  ),
                ),
              ),
              const Center(
                  child: MyProgressIndicator(
                size: 21,
                margin: EdgeInsets.zero,
              )),
            ],
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '@${uploadPost.user.username}',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: textColor),
              ),
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer
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
                      transform: const GradientRotation(4.75),
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
                        Theme.of(context).colorScheme.secondary,
                        barIsTransparent
                            ? Colors.white
                            : Theme.of(context)
                                .dividerColor
                                .withOpacity(themeIsLight ? 0.5 : 1)
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
                  padding: const EdgeInsets.all(2),
                  width: 24,
                  height: 21,
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${progress.ceil()}%',
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: textColor),
                    ),
                  ))
            ],
          ),
          const SizedBox(width: 5),
          MyTextButton(
              text: 'Cancel',
              onPressed: () {
                uploadPost.cancel(context);
              },
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
    );
  }
}

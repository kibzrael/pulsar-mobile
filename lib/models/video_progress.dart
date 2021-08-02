import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pulsar/providers/video_provider.dart';
// import 'package:video_player/video_player.dart';

class VideoProgress extends StatefulWidget {
  @override
  _VideoProgressState createState() => _VideoProgressState();
}

class _VideoProgressState extends State<VideoProgress> {
  @override
  Widget build(BuildContext context) {
    // VideoProvider provider = Provider.of<VideoProvider>(context);
    // VideoPlayerController? controller = provider.videoPlayerController;
    // bool isPlaying = false;

    // int maxDuration = 1;
    // int duration = 0;

    // if (controller != null) {
    //   if (controller.value.isInitialized) {
    //     maxDuration = controller.value.duration.inMilliseconds;
    //     controller.position.then((value) {
    //       if (value != null) {
    //         duration = value.inMilliseconds;
    //         isPlaying = true;
    //       }
    //     });
    //   }
    // } else {
    //   isPlaying = false;
    // }

    return Container(
      height: 5,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).dividerColor,
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).dividerColor
              ]),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          )),
      // child: LinearProgressIndicator(
      //   color: Theme.of(context).accentColor,
      //   backgroundColor: Colors.transparent,
      // )

      // StreamBuilder(stream: controller!.position.asStream(),
      // builder: (context,snapshot){
      //   return
      // }),
    );
  }
}

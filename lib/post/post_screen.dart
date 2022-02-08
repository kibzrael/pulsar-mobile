import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/post/camera_screen.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/route.dart';

class PostProcess extends StatefulWidget {
  final Challenge? challenge;
  final String? tag;

  PostProcess({this.challenge, this.tag});

  @override
  _PostProcessState createState() => _PostProcessState();
}

class _PostProcessState extends State<PostProcess> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostProvider>(
        create: (context) => PostProvider(
              challenge: widget.challenge,
              caption: widget.tag == null ? '' : '#${widget.tag}',
            ),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Navigator(
                initialRoute: '/',
                onGenerateRoute: (settings) {
                  return myPageRoute(
                      builder: (_) => CameraScreen(onPop: () {
                            Navigator.pop(context);
                          }),
                      settings: settings);
                }),
          );
        });
  }
}

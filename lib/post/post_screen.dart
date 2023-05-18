import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/post/camera_screen.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/widgets/route.dart';

class PostProcess extends StatefulWidget {
  final Challenge? challenge;
  final String? tag;

  const PostProcess({Key? key, this.challenge, this.tag}) : super(key: key);

  @override
  State<PostProcess> createState() => _PostProcessState();
}

class _PostProcessState extends State<PostProcess> {
  GlobalKey<NavigatorState> navigator = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostProvider>(
        create: (context) => PostProvider(
              challenge: widget.challenge,
              caption: widget.tag == null ? '' : '#${widget.tag}',
            ),
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              NavigatorState? navigatorState = navigator.currentState;
              if (navigatorState?.canPop() ?? false) {
                navigatorState?.pop();
                return false;
              }
              return true;
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Navigator(
                  initialRoute: '/',
                  key: navigator,
                  onGenerateRoute: (settings) {
                    return myPageRoute(
                        builder: (_) => CameraScreen(onPop: () {
                              Navigator.pop(context);
                            }),
                        settings: settings);
                  }),
            ),
          );
        });
  }
}

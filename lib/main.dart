import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/intro/intro.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/providers/camera_provider.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/providers/messages_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/video_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Pulsar());
}

class Pulsar extends StatefulWidget {
  @override
  _PulsarState createState() => _PulsarState();
}

class _PulsarState extends State<Pulsar> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<MessagesProvider>(
          create: (_) => MessagesProvider(),
        ),
        ChangeNotifierProvider<VideoProvider>(
          create: (_) => VideoProvider(),
        ),
        ChangeNotifierProvider<CameraProvider>(
          create: (_) => CameraProvider(),
        ),
      ],
      builder: (context, child) {
        return Consumer<LoginProvider>(
            builder: (context, loginProvider, child) {
          return Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
            return MaterialApp(
              title: 'Pulsar',
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              theme: themeProvider.theme,
              routes: {
                '/': (context) =>
                    loginProvider.loggedIn! ? BasicRoot() : IntroPage(),
              },
            );
          });
        });
      },
    );
  }
}

// class Pulsar extends StatefulWidget {
//   @override
//   _PulsarState createState() => _PulsarState();
// }

// class _PulsarState extends State<Pulsar> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         VideoPlayerController.asset('assets/posts/tahlia stanton/video 1.mp4')
//           ..initialize().then((_) {
//             // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//             setState(() {});
//           });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Demo',
//       home: Scaffold(
//         body: Center(
//           child: _controller.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//               : Container(),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _controller.value.isPlaying
//                   ? _controller.pause()
//                   : _controller.play();
//             });
//           },
//           child: Icon(
//             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

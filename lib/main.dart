import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/intro/intro.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/providers/ad_provider.dart';
import 'package:pulsar/providers/background_operations.dart';
import 'package:pulsar/providers/camera_provider.dart';
import 'package:pulsar/providers/connectivity_provider.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/providers/messages_provider.dart';
import 'package:pulsar/providers/settings_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/providers/video_provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  String dbPath = join(await getDatabasesPath(), 'pulsar.db');

  Database db = await openDatabase(dbPath, version: 1, onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT UNIQUE, category TEXT, thumbnail TEXT,medium TEXT,high TEXT, fullname TEXT, email TEXT, phone TEXT, bio TEXT, portfolio TEXT, token TEXT)');
  });
  List<Map<String, dynamic>> users = await db.query('users');
  bool loggedIn = users.isNotEmpty;
  Map<String, dynamic>? user = loggedIn ? users[0] : null;
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('settings');
  runApp(Pulsar(
    loggedIn: loggedIn,
    user: user,
  ));
}

class Pulsar extends StatefulWidget {
  final bool loggedIn;
  final Map<String, dynamic>? user;

  const Pulsar({Key? key, required this.loggedIn, this.user}) : super(key: key);

  @override
  _PulsarState createState() => _PulsarState();
}

class _PulsarState extends State<Pulsar> {
  late Future<InitializationStatus> adFuture;

  late bool loggedIn;

  @override
  void initState() {
    super.initState();
    adFuture = MobileAds.instance.initialize();
    loggedIn = widget.loggedIn;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    // SystemChrome.setEnabledSystemUIOverlays(
    //     [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    Brightness systemBrightness =
        SchedulerBinding.instance!.window.platformBrightness;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(widget.user),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(widget.loggedIn),
        ),
        ChangeNotifierProvider<SignInfoProvider>(
          create: (_) => SignInfoProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(systemBrightness),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) => ConnectivityProvider(
              dataSaver: true), // Get datasaver from settings
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
        Provider.value(value: AdProvider(adFuture)),
        ChangeNotifierProvider<BackgroundOperations>(
          create: (_) => BackgroundOperations(),
        ),
      ],
      builder: (context, child) {
        return Consumer<LoginProvider>(
            builder: (context, loginProvider, child) {
          return Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
            WidgetsBinding.instance!.window.onPlatformBrightnessChanged = () {
              themeProvider.systemBrightness =
                  WidgetsBinding.instance!.window.platformBrightness;
              themeProvider.onSystemBrightnessChange();
            };
            return MaterialApp(
              title: 'Pulsar',
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeProvider.themeMode,
              scrollBehavior: MyScrollBehavior(),
              routes: {
                '/': (context) => loginProvider.loggedIn!
                    ? const BasicRoot()
                    : const IntroPage(),
              },
            );
          });
        });
      },
    );
  }
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return GlowingOverscrollIndicator(
      child: child,
      axisDirection: details.direction,
      color: Theme.of(context).cardColor.withOpacity(0.15),
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

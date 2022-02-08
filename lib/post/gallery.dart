// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// import 'package:flutter_video_info/flutter_video_info.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pulsar/classes/icons.dart';
// import 'package:pulsar/functions/time.dart';
// import 'package:pulsar/post/capture_screen.dart';
// import 'package:pulsar/post/post_provider.dart';
// import 'package:pulsar/widgets/bottom_sheet.dart';
// import 'package:pulsar/widgets/route.dart';

// class Gallery extends StatefulWidget {
//   @override
//   _GalleryState createState() => _GalleryState();
// }

// class _GalleryState extends State<Gallery> {
//   String value = 'Gallery';

//   List<VideoFile> videos = [];

//   @override
//   void initState() {
//     super.initState();
//     onIntialize();
//   }

//   onIntialize() async {
//     PermissionStatus readFilesStatus = await Permission.storage.status;
//     if (readFilesStatus.isLimited || readFilesStatus.isDenied) {
//       PermissionStatus status = await Permission.storage.request();
//       if (status.isGranted) {
//         fetchMedia();
//       }
//     } else if (readFilesStatus.isPermanentlyDenied) {
//     } else if (readFilesStatus.isRestricted) {
//     } else {
//       fetchMedia();
//     }
//   }

//   fetchMedia() async {
//     Directory root = Directory('/storage/emulated/0');
//     root.list(recursive: true).listen((element) async {
//       if (element.path.endsWith('.mp4')) {
//         VideoFile video = VideoFile(element.path);
//         setState(() {
//           videos.add(video);
//           print(video.path);
//         });
//         // VideoCompress.getByteThumbnail(
//         //   video.path,
//         //   quality: 75,
//         //   position: 1,
//         // ).then((thumbnail) {
//         //   video.thumbnail = thumbnail;
//         //   setState(() {});
//         // });

//         FlutterVideoInfo().getVideoInfo(video.path).then((info) {
//           video.duration = info?.duration?.ceil();
//           setState(() {});
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MyBottomSheet(
//         fullDialog: true,
//         title: AppBar(
//           title: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('$value'),
//               Padding(
//                 padding: EdgeInsets.only(left: 5, top: 3),
//                 child: Icon(MyIcons.arrowDown),
//               )
//             ],
//           ),
//         ),
//         child: GridView.builder(
//             itemCount: videos.length,
//             padding: EdgeInsets.all(5),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 childAspectRatio: 0.8,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10),
//             itemBuilder: (context, index) {
//               VideoFile video = videos[index];
//               String duration() {
//                 int seconds = video.duration == null
//                     ? 0.toInt()
//                     : (video.duration! ~/ 1000);
//                 return videoDuration(seconds);
//               }

//               return InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(myPageRoute(
//                       builder: (context) => CaptureScreen(
//                           VideoCapture(File(video.path), camera: false))));
//                 },
//                 child: Container(
//                   alignment: Alignment.bottomCenter,
//                   padding: EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                       color: Theme.of(context).inputDecorationTheme.fillColor,
//                       image: video.thumbnail != null
//                           ? DecorationImage(
//                               image: MemoryImage(video.thumbnail!),
//                               fit: BoxFit.cover)
//                           : null,
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Row(
//                     children: [
//                       Icon(MyIcons.play),
//                       SizedBox(width: 3),
//                       Text('${duration()}'),
//                     ],
//                   ),
//                 ),
//               );
//             }));
//   }
// }

// class VideoFile {
//   String path;
//   int? duration;
//   Uint8List? thumbnail;

//   VideoFile(this.path, {this.duration, this.thumbnail});
// }

//   // Isolate? _isolate;
//   // bool _running = false;
//   // late ReceivePort _receivePort;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   onIntialize();
//   // }

//   // onIntialize() async {

//   //    startFetch();

//   // }

//   // startFetch() async {
//   //   if (_running) {
//   //     return;
//   //   }
//   //   setState(() {
//   //     _running = true;
//   //   });
//   //   _receivePort = ReceivePort();
//   //   _isolate = await Isolate.spawn(isolateHandler, _receivePort.sendPort);
//   // }

//   // static void isolateHandler(SendPort port) {
//   //   fetchMedia(port);
//   // }

//   // handleMessage(video) {
//   //   if (video is VideoFile) {
//   //     setState(() {
//   //       videos.add(video);
//   //     });
//   //   }
//   //   if (video is String) {
//   //     stopIsolate();
//   //   }
//   // }

//   // stopIsolate() {
//   //   _running = false;
//   //   _receivePort.close();
//   //   _isolate?.kill(priority: Isolate.immediate);
//   //   _isolate = null;
//   //   setState(() {});
//   // }

//   // static void fetchMedia(SendPort port) async {
//   //   Directory root = Directory('/storage/emulated/0');
//   //   root.list(recursive: true).listen((element) async {
//   //     if (element.path.endsWith('.mp4')) {
//   //       VideoFile video = VideoFile(element.path);

//   //       video.thumbnail = await VideoCompress.getByteThumbnail(
//   //         video.path,
//   //         quality: 75,
//   //         position: 1,
//   //       );

//   //       VideoData? data = await FlutterVideoInfo().getVideoInfo(video.path);
//   //       video.duration = data?.duration?.ceil();

//   //       port.send(video);
//   //     }
//   //   },onDone: (){
//   //     port.send('done');
//   //   });
//   // }

import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late FileManagerController controller;

  @override
  void initState() {
    super.initState();
    controller = FileManagerController();
  }

  @override
  Widget build(BuildContext context) {
    return FileManager(
      controller: controller,
      builder: (context, snapshot) {
        final List<FileSystemEntity> entities = snapshot;
        return ListView.builder(
          itemCount: entities.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: FileManager.isFile(entities[index])
                    ? Icon(Icons.feed_outlined)
                    : Icon(Icons.folder),
                title: Text(FileManager.basename(entities[index])),
                onTap: () {
                  if (FileManager.isDirectory(entities[index])) {
                    controller.openDirectory(entities[index]); // open directory
                  } else {
                    // Perform file-related tasks.
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

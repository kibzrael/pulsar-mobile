import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/files.dart';
import 'package:pulsar/functions/upload_post.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/providers/background_operations.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;

part 'post_provider.g.dart';

class PostProvider extends ChangeNotifier {
  VideoCapture? video;

  Filter filter = original;

  Audio? audio;

  VideoThumbnail thumbnail = VideoThumbnail(position: 0.0);
  List<Uint8List?> thumbnails = [];

  String caption;

  Challenge? challenge;

  bool location = true;
  bool allowcomments = true;
  bool save = true;

  int rotate = 0;

  int maxDuration = 90000;

  double aspectRatio = 1;

  List<Interest> tags = [];

  List<Map<String, String>> resolutions = [
    {
      'name': 'low',
      'fps': '21',
      'frame size': '240',
      'audio bitrate': '64K',
      'video bitrate': '320K',
    },
    {
      'name': 'medium',
      'fps': '24',
      'frame size': '360',
      'audio bitrate': '96K',
      'video bitrate': '480K',
    },
    {
      'name': 'high',
      'fps': '27',
      'frame size': '480',
      'audio bitrate': '128K',
      'video bitrate': '640K',
    },
  ];

  List<String> outputs = [];

  PostProvider({this.challenge, this.caption = ''});

  compress({int? duration}) async {
    try {
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          video!.video.path,
          frameRate: 27,
          quality: VideoQuality.LowQuality);
      String originalSize = fileSize(video!.video.lengthSync());
      if (mediaInfo?.file != null) video!.video = mediaInfo!.file!;
      String compressedSize = fileSize(video!.video.lengthSync());
      Fluttertoast.showToast(
          msg:
              'original size: $originalSize\ncompressed size: $compressedSize\nwidth: ${mediaInfo?.width}\nheight: ${mediaInfo?.height}');
      // ignore: empty_catches
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    if (duration != null) getThumbnails(duration);
  }

  getThumbnails(int duration) async {
    thumbnails.clear();
    maxDuration = duration < 90000 ? duration.floor() : 90000;
    int stepSize = maxDuration ~/ 9;
    for (int step = 0; step < duration / stepSize; step++) {
      int position = stepSize * step;
      try {
        Uint8List? thumbnailData = await thumb.VideoThumbnail.thumbnailData(
            video: video!.video.path, timeMs: position);
        if (step == 0) {
          thumbnail.thumbnail = thumbnailData;
        }
        thumbnails.add(thumbnailData);
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  setThumbnail(int position) async {
    try {
      Duration startPoint = Duration(milliseconds: position);
      Directory tempDirectory = await getTemporaryDirectory();
      String now = DateTime.now().toString().replaceAll(' ', '');
      String outputPath = '${tempDirectory.absolute.path}/Thumbnail$now.jpg';

      String command =
          ' -ss $startPoint -i "${video!.video.absolute.path}" -frames:v 1  -c:a copy $outputPath';

      await FFmpegKit.executeAsync(command, (FFmpegSession session) async {
        String state =
            FFmpegKitConfig.sessionStateToString(await session.getState());
        ReturnCode? returnCode = await session.getReturnCode();
        debugPrint(
            "FFmpeg process exited with state $state and rc $returnCode");

        if (ReturnCode.isSuccess(returnCode)) {
          // Fluttertoast.showToast(msg: outputPath);
          thumbnail = VideoThumbnail(
              position: position.toDouble(),
              thumbnail: await File(outputPath).readAsBytes());
          notifyListeners();
        } else {
          Fluttertoast.showToast(msg: "Error");
        }
      }, (Log log) {
        debugPrint(log.getMessage());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  editVideo(Function() onDone) async {
    try {
      Directory tempDirectory = await getTemporaryDirectory();
      String now = DateTime.now().toString().replaceAll(' ', '');
      String command = ' -i "${video!.video.absolute.path}" ';

      for (Map<String, String> resolution in resolutions) {
        String outputPath =
            '${tempDirectory.absolute.path}/video$now-${resolution['name']}.jpg';
        command += '-vf scale=${resolution['frame size']}:-2 ';
        command += '-r ${resolution['fps']} ';
        command += '-b:v ${resolution['video bitrate']} ';
        command += '-b:a ${resolution['audio bitrate']} ';
        command += outputPath;
        outputs.add(outputPath);
      }

      await FFmpegKit.executeAsync(command, (FFmpegSession session) async {
        String state =
            FFmpegKitConfig.sessionStateToString(await session.getState());
        ReturnCode? returnCode = await session.getReturnCode();
        debugPrint(
            "FFmpeg process exited with state $state and rc $returnCode");

        if (ReturnCode.isSuccess(returnCode)) {
          onDone();
          notifyListeners();
        } else {
          Fluttertoast.showToast(msg: "Error: ${returnCode.toString()}");
        }
      }, (Log log) {
        debugPrint(log.getMessage());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  upload(context) {
    BackgroundOperations operations =
        Provider.of<BackgroundOperations>(context, listen: false);

    User user = Provider.of<UserProvider>(context, listen: false).user;

    if (video == null || thumbnail.thumbnail == null) return;

    // TODO: Split videos before uploading
    // editVideo(() {
    operations.uploadPost = UploadPost(
        user: user,
        video: video!.video,
        medium: video!.video,
        low: video!.video,
        // video: File(outputs[2]),
        // medium: File(outputs[1]),
        // low: File(outputs[0]),
        thumbnail: thumbnail.thumbnail!,
        caption: caption,
        allowComments: allowcomments,
        challenge: challenge,
        tags: tags,
        save: save,
        filter: filter.name,
        token: user.token ?? '');
    operations.uploadPost?.upload(context);
    operations.notify();
    // });
  }

  notify() {
    notifyListeners();
  }
}

class VideoCapture {
  bool camera;
  File video;
  double speed = 1;

  VideoCapture(
    this.video, {
    required this.camera,
  });
}

class VideoThumbnail {
  final double position;
  Uint8List? thumbnail;

  VideoThumbnail({required this.position, this.thumbnail});
}

@JsonSerializable(explicitToJson: true)
class Audio {
  int id;
  Photo coverPhoto;
  String name;
  String artist;

  Audio(
    this.id, {
    required this.coverPhoto,
    required this.name,
    required this.artist,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);
  Map<String, dynamic> toJson() => _$AudioToJson(this);
}

@JsonSerializable()
class Filter {
  String name;
  List<double> convolution;

  Filter(this.name, {required this.convolution});

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);
  Map<String, dynamic> toJson() => _$FilterToJson(this);
}

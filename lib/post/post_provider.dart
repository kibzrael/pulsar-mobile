import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/upload_post.dart';
import 'package:pulsar/post/filters.dart';
import 'package:pulsar/providers/background_operations.dart';
import 'package:pulsar/providers/user_provider.dart';
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

  int rotate = 0;

  int maxDuration = 90000;

  PostProvider({this.challenge, this.caption = ''});

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

        // await VideoCompress.getByteThumbnail(video.video.path,
        //     position: position * 1000);
        thumbnails.add(thumbnailData);
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  upload(context) {
    BackgroundOperations operations =
        Provider.of<BackgroundOperations>(context, listen: false);

    User user = Provider.of<UserProvider>(context, listen: false).user;

    if (video == null || thumbnail.thumbnail == null) return;

    operations.uploadPost = UploadPost(
        user: user,
        video: video!.video,
        thumbnail: thumbnail.thumbnail!,
        token: user.token ?? '');
    operations.uploadPost?.upload(context);
    operations.notify();
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

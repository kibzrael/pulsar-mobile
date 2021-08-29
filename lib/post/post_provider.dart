import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/test_user.dart';
import 'package:pulsar/functions/upload_post.dart';
import 'package:pulsar/providers/background_operations.dart';
import 'package:pulsar/providers/user_provider.dart';

class PostProvider extends ChangeNotifier {
  VideoCapture? video;

  Filter? filter;

  Audio? audio;

  VideoThumbnail thumbnail = VideoThumbnail(position: 0);

  String caption;

  Challenge? challenge;

  bool location = true;

  PostProvider({this.challenge, this.caption = ''});

  upload(context) {
    BackgroundOperations operations =
        Provider.of<BackgroundOperations>(context, listen: false);

    User? user = Provider.of<UserProvider>(context, listen: false).user;

    if (user == null || video == null || thumbnail.thumbnail == null) return;

    operations.uploadPost = UploadPost(
      user: user,
      video: video!.video,
      thumbnail: thumbnail.thumbnail!,
    );
    operations.uploadPost?.upload();
    operations.notify();
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

class Audio {
  int id;
  String coverPhoto;
  String name;
  String artist;

  Audio(
    this.id, {
    required this.coverPhoto,
    required this.name,
    required this.artist,
  });
}

class Filter {}

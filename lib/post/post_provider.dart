import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';

class PostProvider extends ChangeNotifier {
  VideoCapture? video;

  Filter? filter;

  Audio? audio;

  Uint8List? thumbnail;

  String caption;

  Challenge? challenge;

  bool location = true;

  PostProvider({this.challenge, this.caption = ''});
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

class Audio {}

class Filter {}

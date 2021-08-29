import 'dart:io';
import 'dart:typed_data';

import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/test_user.dart';

class UploadPost {
  User user;
  Challenge? challenge;
  File video;
  Uint8List thumbnail;
  String? caption;
  String? location;
  List<String> linkedAccounts;

  UploadPost({
    required this.user,
    required this.video,
    required this.thumbnail,
    this.challenge,
    this.caption,
    this.location,
    this.linkedAccounts = const [],
  });

  upload() async {}
}

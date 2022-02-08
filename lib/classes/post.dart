import 'package:flutter/material.dart';
import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/classes/report.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/classes/video.dart';

class Post {
  int id;
  User user;
  Video video;
  String? caption;
  bool? allowComments;
  int? likes;
  int? comments;
  int? reposts;
  DateTime? time;

  bool? isLiked;
  bool? isReposted;

  String get url => '';

  Post(
    this.id, {
    required this.user,
    required this.video,
    this.allowComments,
    this.caption,
    this.isLiked,
    this.isReposted,
    this.likes,
    this.time,
  });

  Post.fromJson(Map<String, dynamic> info)
      : assert(info['id'] != null),
        assert(info['id'] is int),
        assert(info['user'] != null),
        id = info['id'],
        user = User.fromJson(info['user']),
        allowComments = info['allowComment'],
        caption = info['caption'],
        video = Video.fromJson(info['video']),
        comments = info['comments'],
        isLiked = info['isLiked'],
        isReposted = info['isReposted'],
        likes = info['likes'],
        time = DateTime.tryParse(info['time'] ?? '');

  Map<String, dynamic> toJson(BuildContext context) {
    return {
      'id': this.id,
      'user': this.user.toJson(context),
      'caption': this.caption,
      'video': this.video.toJson(),
      'time': this.time
    };
  }

  // app level
  markAsSeen(BuildContext context) {}

  // user level
  like(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}
  // repost(BuildContext context,
  //     {RequestMethod mode = RequestMethod.post, String comment}) {}
  save(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  comment(BuildContext context, Comment comment) {}

  notInterested() {
    // a survey card for why not interested
  }

  report(Report report) {}

  edit(BuildContext context) {}

  delete(BuildContext context) {}
}

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/report.dart';
import 'package:pulsar/classes/user.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int id;
  User user;
  Video source;
  Photo thumbnail;
  String? caption;
  Challenge? challenge;
  bool allowComments;

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
    required this.source,
    required this.thumbnail,
    this.challenge,
    this.allowComments = true,
    this.caption,
    this.isLiked,
    this.isReposted,
    this.likes,
    this.time,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

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

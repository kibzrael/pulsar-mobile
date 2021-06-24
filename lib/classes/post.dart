import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/classes/video.dart';

class Post {
  int id;
  User user;
  Video video;
  String? caption;
  // Location location;
  // List<Media> media;
  bool? allowComments;
  int? likes;
  int? comments;
  // Link postUrl;
  // List<Hashtag> hashtags;
  // Ad ad;
  // Repost repostObject;
  // bool edited;
  DateTime? time;

  //
  bool? isLiked;
  bool? isReposted;
  bool? isSaved;

  Post(
    this.id, {
    required this.user,
    required this.video,
    // this.ad,
    // this.allowComments,
    this.caption,
    // this.comments,
    // this.edited,
    // this.hashtags,
    this.isLiked,
    this.isReposted,
    this.isSaved,
    this.likes,
    // this.location,
    // this.media,
    // this.postUrl,
    // this.repostObject,
    this.time,
  });

  // Post.fromJson(Map<String, dynamic> info)
  //     : assert(info['id'] != null),
  //       assert(info['id'] is int),
  //       assert(info['user'] != null),
  //       id = info['id'],
  //       user = User.fromJson(info['user']),
  //       ad = info['ad'],
  //       allowComments = info['allowComment'],
  //       caption = info['caption'],
  //       comments = info['comments'],
  //       edited = info['edited'],
  //       hashtags = info['hashtags'].map((i) => Hashtag.fromJson(i)).toList(),
  //       isLiked = info['isLiked'],
  //       isReposted = info['isReposted'],
  //       isSaved = info['isSaved'],
  //       likes = info['likes'],
  //       location = Location.fromJson(info['location']),
  //       media = info['media'],
  //       postUrl = info['postUrl'],
  //       repostObject = Repost.fromJson(info['repost']),
  //       time = DateTime.tryParse(info['time']);

  toJson(BuildContext context) {}

  // app level
  markAsSeen(BuildContext context) {}

  // user level
  like(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}
  // repost(BuildContext context,
  //     {RequestMethod mode = RequestMethod.post, String comment}) {}
  save(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  // comment(BuildContext context, Comment comment) {}

  notInterested() {
    // a survey card for why not interested
  }

  // report(Report report) {}

  shareToUser() {}

  shareToLinkedAccounts() {}

  getLikes() {}

  getComments() {}

  // String get getPostUrl {
  //   return postUrl?.url;
  // }

  // promote(Ad ad) {}

  update(BuildContext context) {}

  editPost(BuildContext context) {}

  delete(BuildContext context) {}
}

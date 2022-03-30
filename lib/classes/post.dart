import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/report.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/post.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  int id;
  User user;
  Video source;
  Photo thumbnail;
  String? caption;
  Challenge? challenge;
  bool allowComments;

  int likes;
  int comments;
  int reposts;
  DateTime? time;

  bool isLiked;
  bool isReposted;

  String get url => '';

  Post(
    this.id, {
    required this.user,
    required this.source,
    required this.thumbnail,
    this.challenge,
    this.allowComments = true,
    this.caption,
    this.isLiked = false,
    this.isReposted = false,
    this.likes = 0,
    this.comments = 0,
    this.reposts = 0,
    this.time,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  // app level
  markAsSeen(BuildContext context) {}

  // user level
  like(BuildContext context, {RequestMethod mode = RequestMethod.post}) async {
    User user = Provider.of<UserProvider>(context).user;

    String url = getUrl(PostUrls.like(this));
    http.Response response;
    try {
      if (mode == RequestMethod.post) {
        response = await http
            .post(Uri.parse(url), headers: {'Authorization': user.token ?? ''});
      } else {
        response = await http.delete(Uri.parse(url),
            headers: {'Authorization': user.token ?? ''});
      }
      if (response.statusCode == 200) {
        debugPrint("Success....");
      } else {
        debugPrint('error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // repost(BuildContext context,
  //     {RequestMethod mode = RequestMethod.post, String comment}) {}
  repost(BuildContext context,
      {RequestMethod mode = RequestMethod.post}) async {
    User user = Provider.of<UserProvider>(context).user;

    String url = getUrl(PostUrls.repost(this));
    http.Response response;
    try {
      if (mode == RequestMethod.post) {
        response = await http
            .post(Uri.parse(url), headers: {'Authorization': user.token ?? ''});
      } else {
        response = await http.delete(Uri.parse(url),
            headers: {'Authorization': user.token ?? ''});
      }
      if (response.statusCode == 200) {
        debugPrint("Success....");
      } else {
        debugPrint('error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  comment(BuildContext context, Comment comment) async {
    User user = Provider.of<UserProvider>(context).user;

    String url = getUrl(PostUrls.comment(this));
    http.Response response;
    try {
      Map body = {'comment': comment.comment};
      if (comment.replyTo != null) {
        body.putIfAbsent('replyTo', () => comment.replyTo!.id);
      }

      response = await http.post(Uri.parse(url),
          headers: {'Authorization': user.token ?? ''}, body: body);

      if (response.statusCode == 200) {
        debugPrint("Success....");
      } else {
        debugPrint('error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  notInterested() {
    // a survey card for why not interested
  }

  report(Report report) {}

  edit(BuildContext context) {}

  delete(BuildContext context) {}
}

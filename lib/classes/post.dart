import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/report.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/interactions_sync.dart';
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
  @JsonKey(name: 'allow_comments')
  bool allowComments;

  int likes;
  int comments;
  int reposts;
  DateTime? time;

  @JsonKey(name: 'is_liked')
  bool isLiked;
  @JsonKey(name: 'is_reposted')
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
  like(BuildContext context,
      {RequestMethod mode = RequestMethod.post,
      required Function() onNotify}) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    isLiked = mode == RequestMethod.post;
    mode == RequestMethod.post ? likes++ : likes--;
    syncLike(context);
    onNotify();
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
        Fluttertoast.showToast(msg: "Success....");
      } else {
        isLiked = mode != RequestMethod.post;
        mode == RequestMethod.post ? likes-- : likes++;
        syncLike(context);
        onNotify();
        Fluttertoast.showToast(msg: 'error');
      }
    } catch (e) {
      isLiked = mode != RequestMethod.post;
      mode == RequestMethod.post ? likes-- : likes++;
      syncLike(context);
      onNotify();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  syncLike(BuildContext context) {
    InteractionsSync interactionsSync =
        Provider.of<InteractionsSync>(context, listen: false);
    if (isLiked) {
      interactionsSync.like(this);
    } else {
      interactionsSync.unlike(this);
    }
  }

  // repost(BuildContext context,
  //     {RequestMethod mode = RequestMethod.post, String comment}) {}
  repost(BuildContext context,
      {RequestMethod mode = RequestMethod.post,
      required Function() onNotify}) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    isReposted = mode == RequestMethod.post;
    mode == RequestMethod.post ? reposts++ : reposts--;
    syncRepost(context);
    onNotify();
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
        Fluttertoast.showToast(msg: "Success....");
      } else {
        isReposted = mode != RequestMethod.post;
        mode == RequestMethod.post ? reposts-- : reposts++;
        syncRepost(context);
        onNotify();
        Fluttertoast.showToast(msg: 'error');
      }
    } catch (e) {
      isReposted = mode != RequestMethod.post;
      mode == RequestMethod.post ? reposts-- : reposts++;
      syncRepost(context);
      onNotify();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  syncRepost(BuildContext context) {
    InteractionsSync interactionsSync =
        Provider.of<InteractionsSync>(context, listen: false);
    if (isReposted) {
      interactionsSync.repost(this);
    } else {
      interactionsSync.unrepost(this);
    }
  }

  notInterested() {
    // a survey card for why not interested
  }

  report(Report report) {}

  edit(BuildContext context) {}

  delete(BuildContext context, Function() onDelete) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    String url = PostUrls.postItem(this);

    try {
      http.Response response = await http
          .delete(Uri.parse(url), headers: {'Authorization': user.token ?? ''});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Success...');
        onDelete();
      } else {
        Fluttertoast.showToast(msg: data['message']);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

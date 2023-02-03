import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/post.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  int id;
  User user;
  int post;
  String comment;
  DateTime time;

  @JsonKey(name: 'reply_to')
  int? replyTo;

  int likes;
  int replies;

  @JsonKey(name: 'is_liked')
  bool isLiked;

  Comment(this.id,
      {required this.user,
      required this.post,
      required this.comment,
      this.likes = 0,
      this.replies = 0,
      this.isLiked = false,
      required this.time});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  like(BuildContext context,
      {RequestMethod mode = RequestMethod.post,
      required Function() onNotify}) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    isLiked = mode == RequestMethod.post;
    mode == RequestMethod.post ? likes++ : likes--;
    onNotify();
    String url = getUrl(PostUrls.commentLike(this));
    http.Response response;
    try {
      if (mode == RequestMethod.post) {
        response = await http
            .post(Uri.parse(url), headers: {'Authorization': user.token ?? ''});
      } else {
        response = await http.delete(Uri.parse(url),
            headers: {'Authorization': user.token ?? ''});
      }
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Success....");
      } else {
        isLiked = mode != RequestMethod.post;
        mode == RequestMethod.post ? likes-- : likes++;
        onNotify();
        debugPrint("Comment Like$data");
        Fluttertoast.showToast(msg: 'error');
      }
    } catch (e) {
      isLiked = mode != RequestMethod.post;
      mode == RequestMethod.post ? likes-- : likes++;
      onNotify();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  delete(BuildContext context, Function() onDelete) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    String url = PostUrls.comment(this);

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

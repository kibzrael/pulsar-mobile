import 'package:json_annotation/json_annotation.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  int id;
  User user;
  Post post;
  String comment;
  DateTime time;

  Comment? replyTo;

  int likes;
  int replies;

  Comment(this.id,
      {required this.user,
      required this.post,
      required this.comment,
      this.likes = 0,
      this.replies = 0,
      required this.time});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  like() async {}

  reply(String text) async {}
}

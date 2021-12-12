import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';

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

  like() async {}

  reply(String text) async {}
}

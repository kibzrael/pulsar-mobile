import 'package:flutter/material.dart';
import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/functions/dynamic_count.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/interactions.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final List<Comment> replies;

  CommentCard(this.comment, {this.replies = const []});

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  Comment get comment => widget.comment;

  bool isLiked = false;

  like() {
    setState(() => isLiked = !isLiked);
    comment.like();
  }

  reply() {}

  openProfile() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => ProfilePage(comment.user)));
  }

  @override
  Widget build(BuildContext context) {
    Widget stat(int number, Function() onPressed) => Expanded(
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Text(
                '${roundCount(number)}',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: openProfile,
              child: ProfilePic(comment.user.profilePic, radius: 18)),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: openProfile,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('@${comment.user.username}',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 16.5)),
                      SizedBox(width: 5),
                      Text(
                        '2min',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontSize: 12),
                      )
                    ],
                  ),
                ),
                Text(comment.comment),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LikeButton(
                      liked: isLiked,
                      size: 18,
                      onPressed: like,
                    ),
                    stat(comment.likes, () {}),
                    ReplyButton(
                      size: 18,
                      onPressed: reply,
                    ),
                    stat(comment.replies, () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

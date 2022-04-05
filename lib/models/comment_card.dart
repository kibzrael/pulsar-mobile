import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/dynamic_count.dart';
import 'package:pulsar/functions/time.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/settings/report/report.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/post.dart';
import 'package:pulsar/widgets/interactions.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/route.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final Post post;
  final Function(Comment comment) onReply;
  final List<Comment> replies;
  final List<Map<String, dynamic>> sendingReplies;

  const CommentCard(this.comment,
      {Key? key,
      required this.onReply,
      required this.post,
      this.replies = const [],
      this.sendingReplies = const []})
      : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late UserProvider userProvider;

  Comment get comment => widget.comment;

  bool get isLiked => comment.isLiked;

  List<Comment> replies = [];

  bool isFetchingReplies = false;

  reply() {
    widget.onReply(comment);
  }

  fetchReplies() async {
    setState(() {
      isFetchingReplies = true;
    });
    List<Map<String, dynamic>> comments = [];

    String url;

    url = getUrl(PostUrls.comment(comment.post, index: 0));

    try {
      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': userProvider.user.token ?? ''});

      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        comments = [...List<Map<String, dynamic>>.from(body['comments'])];
      } else {
        Fluttertoast.showToast(msg: body['message']);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    replies = [...replies, ...comments.map((e) => Comment.fromJson(e))];
    setState(() {
      isFetchingReplies = false;
    });
  }

  openProfile() {
    if (comment.user.id != userProvider.user.id) {
      Navigator.of(context)
          .push(myPageRoute(builder: (context) => ProfilePage(comment.user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    Widget stat(int number, Function() onPressed) => Expanded(
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Text(
                roundCount(number),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        );

    return InkWell(
      onLongPress: () {
        SnackBar snackBar =
            [comment.user.id, widget.post.id].contains(userProvider.user.id)
                ? SnackBar(
                    content: const Text('Report This User?'),
                    duration: const Duration(seconds: 10),
                    backgroundColor: Theme.of(context).colorScheme.onError,
                    action: SnackBarAction(
                        label: 'Report',
                        onPressed: () {
                          Navigator.of(context).push(myPageRoute(
                              builder: (context) => ReportScreen(
                                  initialIndex: 1, user: comment.user)));
                        }),
                  )
                : SnackBar(
                    content: const Text('Delete this Comment?'),
                    duration: const Duration(seconds: 10),
                    backgroundColor: Theme.of(context).colorScheme.onError,
                    action: SnackBarAction(
                        label: 'Delete',
                        onPressed: () async {
                          await comment.delete(context);
                          // TODO: remove from comment's list
                        }),
                  );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: openProfile,
                    child: ProfilePic(comment.user.profilePic?.thumbnail,
                        radius: 18)),
                const SizedBox(width: 15),
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
                            const SizedBox(width: 5),
                            Text(
                              timeAgo(comment.time),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      Text(comment.comment),
                      if (comment.replyTo == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            LikeButton(
                              liked: isLiked,
                              size: 18,
                              onPressed: () {
                                setState(() {
                                  comment.like(context,
                                      mode: isLiked
                                          ? RequestMethod.delete
                                          : RequestMethod.post,
                                      onNotify: () => setState(() {}));
                                });
                              },
                            ),
                            stat(comment.likes, () {}),
                            ReplyButton(
                              size: 18,
                              onPressed: reply,
                            ),
                            stat(comment.replies, reply),
                          ],
                        ),
                    ],
                  ),
                ),
                if (comment.replyTo != null)
                  SizedBox(
                    height: 36,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LikeButton(
                            liked: isLiked,
                            size: 18,
                            onPressed: () {
                              setState(() {
                                comment.like(context,
                                    mode: isLiked
                                        ? RequestMethod.delete
                                        : RequestMethod.post,
                                    onNotify: () => setState(() {}));
                              });
                            }),
                        stat(comment.likes, () {}),
                      ],
                    ),
                  )
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...widget.sendingReplies.map((e) => SendingCommentCard(e)),
                  ...widget.replies.map((e) =>
                      CommentCard(e, onReply: (_) {}, post: widget.post)),
                  ...replies.map((e) =>
                      CommentCard(e, onReply: (_) {}, post: widget.post)),
                  if (comment.replies - replies.length > 0)
                    Container(
                        alignment: Alignment.centerLeft,
                        height: 24,
                        padding: const EdgeInsets.only(left: 15),
                        child: isFetchingReplies
                            ? const ThreeDotsProgress(
                                size: 18,
                                margin: EdgeInsets.symmetric(horizontal: 12))
                            : InkWell(
                                onTap: () {
                                  fetchReplies();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  child: ShaderMask(
                                      shaderCallback: (rect) =>
                                          primaryGradient().createShader(rect),
                                      child: Text(
                                        'View${widget.replies.length + replies.length > 0 ? ' More' : ''} Replies',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(color: Colors.white),
                                      )),
                                ),
                              ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SendingCommentCard extends StatefulWidget {
  final Map<String, dynamic> comment;

  const SendingCommentCard(this.comment, {Key? key}) : super(key: key);

  @override
  _SendingCommentCardState createState() => _SendingCommentCardState();
}

class _SendingCommentCardState extends State<SendingCommentCard> {
  Map<String, dynamic> get comment => widget.comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfilePic(comment['user'].profilePic?.thumbnail, radius: 18),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('@${comment['user'].username}',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 16.5)),
                    const SizedBox(width: 5),
                    Text(
                      'now',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontSize: 12),
                    )
                  ],
                ),
                Text((comment['replyTo'] != null
                        ? '@${comment['replyTo'].user.username} '
                        : '') +
                    comment['comment']),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     LikeButton(
                //       liked: isLiked,
                //       size: 18,
                //       onPressed: () {
                //         setState(() {
                //           comment.like(context,
                //               mode: isLiked
                //                   ? RequestMethod.delete
                //                   : RequestMethod.post,
                //               onNotify: () => setState(() {}));
                //         });
                //       },
                //     ),
                //     stat(comment.likes, () {}),
                //     ReplyButton(
                //       size: 18,
                //       onPressed: reply,
                //     ),
                //     stat(comment.replies, () {}),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/models/comment_card.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/post.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/text_input.dart';

class CommentPage extends StatefulWidget {
  final Post post;
  const CommentPage(this.post, {Key? key}) : super(key: key);
  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late ScrollController scrollController;
  late TextEditingController commentController;

  late UserProvider userProvider;

  Post get post => widget.post;

  String comment = '';
  Comment? replyTo;

  List<Comment> userComments = [];
  List<Map<String, dynamic>> sendingComments = [];

  List<Comment> liveReplies = [];
  List<Map<String, dynamic>> sendingReplies = [];

  List<int> removedComments = [];

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    scrollController = ScrollController();
  }

  Future<List<Map<String, dynamic>>> fetchComments(int index) async {
    List<Map<String, dynamic>> comments = [];

    String url;

    url = getUrl(PostUrls.comments(post.id, index: index));

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': userProvider.user.token ?? ''});

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      comments = [...List<Map<String, dynamic>>.from(body['comments'])];
    } else {
      Fluttertoast.showToast(msg: body['message']);
    }

    return comments;
  }

  onReply(Comment comment) {
    setState(() {
      replyTo = comment;
    });
  }

  makeComment() async {
    commentController.clear();
    String sendingComment = comment;
    Comment? sendingReplyTo = replyTo;
    replyTo = null;

    if (scrollController.hasClients && sendingReplyTo == null) {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }

    Map<String, dynamic> commentBody = {
      'user': userProvider.user,
      'comment': sendingComment,
      'replyTo': sendingReplyTo
    };

    if (sendingReplyTo == null) {
      sendingComments.add(commentBody);
    } else {
      sendingReplies.add(commentBody);
    }

    String url;

    url = getUrl(PostUrls.comments(post.id));

    Map<String, dynamic> requestBody = {'comment': sendingComment};
    if (sendingReplyTo != null) {
      requestBody.putIfAbsent('replyTo', () => sendingReplyTo.id.toString());
    }

    setState(() {});

    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Authorization': userProvider.user.token ?? ''},
          body: requestBody);

      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Success...');
        post.comments++;
        debugPrint(body['comment'].toString());
        if (sendingReplyTo == null) {
          userComments.insert(0, Comment.fromJson(body['comment']));
          sendingComments
              .removeWhere((element) => element['comment'] == sendingComment);
        } else {
          liveReplies.insert(0, Comment.fromJson(body['comment']));
          sendingReplies
              .removeWhere((element) => element['comment'] == sendingComment);
        }
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: body['message']);
      }
    } catch (e) {
      debugPrint("Make comment: $e");
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return MyBottomSheet(
      maxRatio: 0.9,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Column(
            children: [
              Flexible(
                child: RecyclerView(
                    target: fetchComments,
                    itemBuilder: (context, snapshot) {
                      List<Map<String, dynamic>> data = [
                        ...sendingComments,
                        ...userComments.map((e) => e.toJson()),
                        ...snapshot.data
                      ]..removeWhere((e) => removedComments.contains(e['id']));

                      return data.isEmpty
                          ? snapshot.errorLoading
                              ? snapshot.noData
                                  ? NoPosts(
                                      alignment: Alignment.center,
                                      message: local(context).noComment,
                                    )
                                  : NetworkError(
                                      onRetry: snapshot.refreshCallback)
                              : const Center(child: MyProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: snapshot.refreshCallback,
                              child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> commentData =
                                        data[index];
                                    if (commentData.containsKey('id')) {
                                      Comment comment =
                                          Comment.fromJson(commentData);

                                      return CommentCard(comment,
                                          onReply: onReply,
                                          post: post,
                                          onDelete: () => setState(() =>
                                              removedComments.add(comment.id)),
                                          replies: [
                                            ...liveReplies.where((element) =>
                                                element.replyTo == comment.id)
                                          ],
                                          sendingReplies: [
                                            ...sendingReplies.where((element) =>
                                                element['replyTo']?.id ==
                                                comment.id)
                                          ]);
                                    } else {
                                      return SendingCommentCard(commentData);
                                    }
                                  }),
                            );
                    }),
              ),
              if (replyTo != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color:
                            Theme.of(context).inputDecorationTheme.fillColor!,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      ProfilePic(replyTo?.user.profilePic?.thumbnail,
                          radius: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: local(context).replyingTo,
                                  children: [
                                    TextSpan(
                                        text: ' @${replyTo?.user.username}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.5))
                                  ]),
                            ),
                            Text(
                              replyTo!.comment,
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => replyTo = null),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(MyIcons.close),
                        ),
                      )
                    ],
                  ),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(
                  children: [
                    Flexible(
                      child: MyTextInput(
                        hintText: '${local(context).makeAComment}...',
                        maxLines: 7,
                        height: null,
                        controller: commentController,
                        padding: EdgeInsets.fromLTRB(
                            4, 2, comment.isEmpty ? 4 : 8, 2),
                        prefix: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                            child: ProfilePic(
                                userProvider.user.profilePic?.thumbnail,
                                radius: 18)),
                        onChanged: (text) {
                          setState(() {
                            comment = text;
                          });
                        },
                        onSubmitted: (text) {
                          if (comment.isNotEmpty && comment.trim() != '') {
                            setState(() {});
                            // await for message to be added
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (comment.isNotEmpty && comment.trim() != '') {
                          makeComment();
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.all(2),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21)),
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              gradient: primaryGradient()),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          child: Icon(
                            MyIcons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

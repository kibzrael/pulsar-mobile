import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/comment.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/models/comment_card.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/text_input.dart';

class CommentPage extends StatefulWidget {
  final Post post;
  CommentPage(this.post);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late TextEditingController commentController;

  Post get post => widget.post;

  String comment = '';
  Comment? replyTo;

  List<Map<String, dynamic>> userComments = [];

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  Future<List<Map<String, dynamic>>> fetchComments(int index) async {
    List<Map<String, dynamic>> comments = [];
    await Future.delayed(Duration(seconds: 2));
    for (int i = 0; i < 12; i++) {
      comments.add({
        'id': i,
        'user': allUsers[i],
        'post': post,
        'comment':
            'Comment on the post which occupies multiple lines. The minimum number of lines that can appear at once is three or seven if with attachment but the comment can be expanded to view more.',
        'time': DateTime.now().subtract(Duration(hours: i * index)),
      });
    }

    return comments;
  }

  onReply(Comment comment) {
    setState(() {
      replyTo = comment;
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        ...userComments,
                        ...snapshot.data
                      ];

                      return data.isEmpty
                          ? snapshot.errorLoading
                              ? snapshot.noData
                                  ? Center(
                                      child: Text(
                                          'There are no comments\nfor this post yet.'))
                                  : Center(child: Text('No Network'))
                              : Center(child: MyProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: snapshot.refreshCallback,
                              child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> comment = data[index];

                                    return CommentCard(
                                        Comment(comment['id'],
                                            user: comment['user'],
                                            post: comment['post'],
                                            comment: comment['comment'],
                                            time: comment['time'],
                                            likes: 1302,
                                            replies: 423),
                                        onReply: onReply);
                                  }),
                            );
                    }),
              ),
              if (replyTo != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                      ProfilePic(replyTo?.user.profilePic, radius: 18),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              text: TextSpan(text: 'replying to', children: [
                                TextSpan(
                                    text: ' @${replyTo?.user.username}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.5))
                              ]),
                            ),
                            Text(
                              replyTo!.comment,
                              style: Theme.of(context).textTheme.subtitle2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => replyTo = null),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(MyIcons.close),
                        ),
                      )
                    ],
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(
                  children: [
                    Flexible(
                      child: MyTextInput(
                        hintText: 'Make a comment...',
                        maxLines: 7,
                        height: null,
                        controller: commentController,
                        padding: EdgeInsets.fromLTRB(
                            4, 2, comment.length < 1 ? 4 : 8, 2),
                        prefix: Padding(
                            padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                            child: ProfilePic(tahlia.profilePic, radius: 18)),
                        onChanged: (text) {
                          setState(() {
                            comment = text;
                          });
                        },
                        onSubmitted: (text) {
                          if (comment.length > 0 && comment.trim() != '') {
                            setState(() {});
                            // await for message to be added
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        if (comment.length > 0 && comment.trim() != '') {
                          setState(() {
                            userComments.add({
                              'id': 21,
                              'user': Provider.of<UserProvider>(context,
                                      listen: false)
                                  .user!,
                              'post': post,
                              'comment': comment,
                              'replyTo': replyTo,
                              'time': DateTime.now()
                            });
                            commentController.text = '';
                            comment = '';
                            replyTo = null;
                          });
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.all(2),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21)),
                        child: Container(
                          child: Icon(
                            MyIcons.send,
                            color: Colors.white,
                          ),
                          height: 42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              gradient: primaryGradient()),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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

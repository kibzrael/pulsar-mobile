import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dynamic_count.dart';
import 'package:pulsar/widgets/interactions.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  moreOnComment() {}
  @override
  Widget build(BuildContext context) {
    Widget stat(int number, Function() onPressed) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 5),
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
          ),
        );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              backgroundColor: Theme.of(context).dividerColor, radius: 18),
          SizedBox(width: 5),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('@username',
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
              Text(
                'Comment on the post which occupies multiple lines. The minimum number of lines that can appear at once is three but the comment can be expanded to view more.',
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    LikeButton(
                      liked: false,
                      size: 18,
                    ),
                    stat(1300, () {}),
                    ReplyButton(
                      size: 18,
                    ),
                    stat(1300, () {}),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class OldCommentCard extends StatefulWidget {
  @override
  _OldCommentCardState createState() => _OldCommentCardState();
}

class _OldCommentCardState extends State<OldCommentCard> {
  moreOnComment() {}

  @override
  Widget build(BuildContext context) {
    Widget stat(int number, Function() onPressed) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child: InkWell(
              onTap: onPressed,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Text('${roundCount(number)}'),
              ),
            ),
          ),
        );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      margin: EdgeInsets.only(bottom: 12),
      child: Row(children: [
        CircleAvatar(
            backgroundColor: Theme.of(context).dividerColor, radius: 18),
        SizedBox(width: 5),
        LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  // Navigator.of(context)
                  //     .push(myPageRoute(builder: (context) => ProfilePage()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('@username',
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
                      InkWell(
                        onTap: moreOnComment,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(MyIcons.more),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                '${constraints.maxHeight}',
                //'Comment on the post which occupies multiple lines. The minimum number of lines that can appear at once is three but the comment can be expanded to view more.',
                maxLines: 3,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    LikeButton(
                      liked: false,
                    ),
                    stat(1300, () {}),
                    ReplyButton(),
                    stat(1300, () {}),
                  ],
                ),
              ),
            ],
          );
        }),
      ]),
    );
  }
}

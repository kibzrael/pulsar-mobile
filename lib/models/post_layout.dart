import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/functions/dynamic_count.dart';
import 'package:pulsar/options/post_options.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/secondary_pages.dart/comment_page.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/secondary_pages.dart/tag_page.dart';
import 'package:pulsar/widgets/interactions.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/models/post_video.dart';

class PostLayout extends StatefulWidget {
  final Post post;
  final bool isInView;
  final bool stretch;
  PostLayout(this.post, {this.isInView = false, required this.stretch});

  @override
  _PostLayoutState createState() => _PostLayoutState();
}

class _PostLayoutState extends State<PostLayout> {
  late Post post;

  bool isLiked = false;
  bool isReposted = false;
  bool isFollowing = false;

  int likes = 12304;
  int comments = 430;
  int reposts = 127;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  //to be removed
  void like() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void comment() {
    // openBottomSheet(context, (context) => CommentPage());
  }

  //to be removed
  void repost() {
    setState(() {
      isReposted = !isReposted;
    });
  }

  //to be removed
  void share() {}

  //to be removed
  void follow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);

    Widget stat(int number, Function() onPressed) => Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text('${roundCount(number)}')),
            ),
          ),
        );

    return Container(
      child: Stack(
        children: [
          PostVideo(
            post.video,
            isInView: widget.isInView,
          ),
          Column(children: [
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.white12, shape: BoxShape.circle),
                      child: Icon(
                        MyIcons.music,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Calum Scott - Biblical',
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 5, left: 21),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) => ProfilePage(post.user)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ProfilePic(
                                  post.user.profilePic,
                                  radius: 21,
                                  onMedia: true,
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  '@${post.user.username}',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
                                                      .copyWith(
                                                          fontSize: 16.5)),
                                            ),
                                            SizedBox(width: 5),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 2.0),
                                              child: Text(
                                                '2min',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        fontSize: 12,
                                                        color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.all(1.5),
                                                child: ShaderMask(
                                                  shaderCallback: (rect) {
                                                    return LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        colors: [
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                          Theme.of(context)
                                                              .buttonColor
                                                        ]).createShader(rect);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 5,
                                                        height: 5,
                                                        margin: EdgeInsets.only(
                                                            right: 2.5),
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                      Text(
                                                        'Follow',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                fontSize: 13.5),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 2.5),
                                        Flexible(
                                          child: Text('Challenge',
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ),
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'Caption of the post. Has soft wrap\nOccupies max of three lines\nno read more...',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 8,
                            runSpacing: 7.5,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            children: [
                              Tag('photography'),
                              Tag('music'),
                              Tag('dance'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 75,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LikeButton(
                          liked: isLiked,
                          size: 30,
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                        ),
                        stat(24300, () {}),
                        Theme(
                          data: provider.theme!,
                          child: Builder(builder: (_) {
                            return Theme(
                              data: Theme.of(context),
                              child: CommentButton(
                                size: 30,
                                onPressed: () {
                                  openBottomSheet(_, (_) => CommentPage());
                                },
                              ),
                            );
                          }),
                        ),
                        stat(24300, comment),
                        RepostButton(
                          reposted: isReposted,
                          size: 30,
                          onPressed: () {
                            setState(() {
                              isReposted = !isReposted;
                            });
                          },
                        ),
                        stat(24300, () {}),
                        Theme(
                            data: provider.theme!,
                            child: Builder(builder: (_) {
                              return Theme(
                                data: Theme.of(context),
                                child: ShareButton(
                                  size: 30,
                                  onPressed: () {
                                    openBottomSheet(
                                        _, (_) => PostOptions(post));
                                  },
                                ),
                              );
                            })),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (widget.stretch) SizedBox(height: kToolbarHeight),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: MediaQuery.of(context).padding.bottom - kToolbarHeight,
            )
          ])
        ],
      ),
    );
  }
}

class ThemeBugFix extends StatelessWidget {
  final Widget child;

  ThemeBugFix({required this.child});

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    return Theme(
      data: provider.theme!,
      child: Builder(
        builder: (context) => child,
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String text;
  Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => TagPage(text)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.5, color: Colors.white70, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          '#$text',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

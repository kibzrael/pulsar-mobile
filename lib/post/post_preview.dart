import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/functions/dynamic_count.dart';
import 'package:pulsar/models/post_layout.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/interactions.dart';
import 'package:pulsar/widgets/profile_pic.dart';

class PostPreview extends StatefulWidget {
  final PostProvider provider;

  PostPreview(this.provider);

  @override
  _PostPreviewState createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  PostProvider get provider => widget.provider;

  @override
  Widget build(BuildContext context) {
    Widget stat(int number) => Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text('${roundCount(number)}',
                    style: TextStyle(fontWeight: FontWeight.w500))),
          ),
        );

    return Theme(
      data: darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('@username'),
          centerTitle: true,
          backgroundColor: Colors.black.withOpacity(0.0),
        ),
        body: Stack(
          children: [
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
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ProfilePic(
                                  tahlia.profilePic,
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
                                              child: Text('@${tahlia.username}',
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
                                                              .colorScheme
                                                              .primaryVariant
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
                      width: 90,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LikeButton(
                            liked: false,
                            size: 36,
                          ),
                          stat(24360),
                          Builder(builder: (_) {
                            return Theme(
                              data: Theme.of(context),
                              child: CommentButton(
                                size: 36,
                              ),
                            );
                          }),
                          stat(24360),
                          RepostButton(
                            reposted: false,
                            size: 36,
                          ),
                          stat(24360),
                          Builder(builder: (_) {
                            return Theme(
                              data: Theme.of(context),
                              child: ShareButton(
                                size: 36,
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // if (stretch) SizedBox(height: kToolbarHeight),
              // AnimatedContainer(
              //   duration: Duration(milliseconds: 500),
              //   height:
              //       MediaQuery.of(context).padding.bottom - kToolbarHeight,
              // )
              SizedBox(
                height: kToolbarHeight,
              )
            ])
          ],
        ),
      ),
    );
  }
}

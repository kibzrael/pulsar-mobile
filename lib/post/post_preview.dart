// ignore_for_file: prefer_const_literals_to_create_immutables

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

  const PostPreview(this.provider, {Key? key}) : super(key: key);

  @override
  _PostPreviewState createState() => _PostPreviewState();
}

class _PostPreviewState extends State<PostPreview> {
  PostProvider get provider => widget.provider;

  @override
  Widget build(BuildContext context) {
    Widget stat(int number) => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(roundCount(number),
                    style: const TextStyle(fontWeight: FontWeight.w500))),
          ),
        );

    return Theme(
      data: darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('@username'),
          centerTitle: true,
          backgroundColor: Colors.black.withOpacity(0.0),
        ),
        body: Stack(
          children: [
            Column(children: [
              SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                            color: Colors.white12, shape: BoxShape.circle),
                        child: Icon(
                          MyIcons.music,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'Calum Scott - Biblical',
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 5, left: 21),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ProfilePic(
                                  tahlia.profilePic?.thumbnail,
                                  radius: 21,
                                  onMedia: true,
                                ),
                                const SizedBox(width: 5),
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
                                            const SizedBox(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2.0),
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
                                            const SizedBox(width: 5),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(1.5),
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
                                                              .primaryContainer
                                                        ]).createShader(rect);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 5,
                                                        height: 5,
                                                        margin: const EdgeInsets
                                                            .only(right: 2.5),
                                                        decoration:
                                                            const BoxDecoration(
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
                                        const SizedBox(height: 2.5),
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
                            padding: const EdgeInsets.symmetric(vertical: 4),
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
                            padding: const EdgeInsets.only(top: 4),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              runSpacing: 7.5,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              children: [
                                const Tag('photography'),
                                const Tag('music'),
                                const Tag('dance'),
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
                          const LikeButton(
                            liked: false,
                            size: 36,
                          ),
                          stat(24360),
                          Builder(builder: (_) {
                            return Theme(
                              data: Theme.of(context),
                              child: const CommentButton(
                                size: 36,
                              ),
                            );
                          }),
                          stat(24360),
                          const RepostButton(
                            reposted: false,
                            size: 36,
                          ),
                          stat(24360),
                          Builder(builder: (_) {
                            return Theme(
                              data: Theme.of(context),
                              child: const ShareButton(
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
              const SizedBox(
                height: kToolbarHeight,
              )
            ])
          ],
        ),
      ),
    );
  }
}

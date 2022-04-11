// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/models/post_layout.dart';
import 'package:pulsar/post/post_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/widgets/caption_text.dart';
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
    User user = Provider.of<UserProvider>(context).user;

    Widget stat() => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: const FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child:
                    Text('0', style: TextStyle(fontWeight: FontWeight.w500))),
          ),
        );

    return Theme(
      data: darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // title: Text('@${user.username}'),
          centerTitle: true,
          backgroundColor: Colors.black.withOpacity(0.0),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          double aspectRatio = constraints.maxWidth / constraints.maxHeight;
          bool stretch = aspectRatio > 0.5;
          return Padding(
            padding: EdgeInsets.only(bottom: stretch ? 0 : kToolbarHeight),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  ColorFiltered(
                    colorFilter:
                        ColorFilter.matrix(provider.filter.convolution),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        image: DecorationImage(
                            image: MemoryImage(provider.thumbnail.thumbnail!),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Column(children: [
                    // if (provider.audio != null)
                    SafeArea(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  color: Colors.white12,
                                  shape: BoxShape.circle),
                              child: Icon(
                                MyIcons.music,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              '${user.username} - Original Audio',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ProfilePic(
                                        user.profilePic?.thumbnail,
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
                                                    child: Text(
                                                        '@${user.username}',
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1!
                                                            .copyWith(
                                                                fontSize:
                                                                    16.5)),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 2.0),
                                                    child: Text(
                                                      'now',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.5),
                                                      child: ShaderMask(
                                                        shaderCallback: (rect) {
                                                          return LinearGradient(
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              colors: [
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primaryContainer
                                                              ]).createShader(
                                                              rect);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 5,
                                                              height: 5,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          2.5),
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                              'Follow',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13.5),
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
                                                child: Text(
                                                    provider.challenge?.name ??
                                                        user.category,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2!
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                              ),
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                                if (provider.caption != '')
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: DetectableText(
                                      text: provider.caption,
                                      detectionRegExp: hastagAtSignExpression(),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      basicStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
                                      detectedStyle:
                                          const TextStyle(color: Colors.blue),
                                      onTap: (String text) {
                                        Fluttertoast.showToast(
                                            msg: "Open $text");
                                      },
                                    ),
                                  ),
                                if (provider.tags.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      spacing: 8,
                                      runSpacing: 7.5,
                                      alignment: WrapAlignment.start,
                                      runAlignment: WrapAlignment.start,
                                      children: [
                                        ...provider.tags.map((e) => Tag(e.name))
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
                                stat(),
                                const CommentButton(
                                  size: 36,
                                ),
                                stat(),
                                const RepostButton(
                                  reposted: false,
                                  size: 36,
                                ),
                                stat(),
                                const ShareButton(
                                  size: 36,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ])
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

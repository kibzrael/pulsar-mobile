import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class HighlightChallege extends StatefulWidget {
  final Challenge challenge;
  const HighlightChallege(this.challenge, {Key? key}) : super(key: key);

  @override
  _HighlightChallegeState createState() => _HighlightChallegeState();
}

class _HighlightChallegeState extends State<HighlightChallege> {
  Challenge get challenge => widget.challenge;
  bool isPinned = false;
  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'New Highlight',
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              myPageRoute(builder: (context) => ChallengePage(challenge)));
        },
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                children: [
                  Container(
                    width: constraints.maxWidth / 2 - 7.5,
                    height: constraints.maxWidth / 2,
                    decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(21),
                        ),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(challenge
                                .coverPhoto
                                .photo(context, max: 'medium')),
                            fit: BoxFit.cover)),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      height: constraints.maxWidth / 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              challenge.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 19.5),
                              maxLines: 2,
                            ),
                            Text(
                              challenge.description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            LayoutBuilder(builder: (context, constraints) {
                              double width = constraints.maxWidth - 12;
                              return Row(
                                children: [
                                  FollowButton(
                                    height: 32,
                                    width: width * 0.6,
                                    isFollowing: isPinned,
                                    text: const {true: "Pinned", false: "Pin"},
                                    onPressed: () =>
                                        setState(() => isPinned = !isPinned),
                                  ),
                                  Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.only(left: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Container(
                                        width: width * 0.4,
                                        height: 32,
                                        padding: const EdgeInsets.all(4),
                                        alignment: Alignment.center,
                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(30),
                                        //     border: Border.all(
                                        //         color:
                                        //             Theme.of(context).dividerColor,
                                        //         style:
                                        //             Theme.of(context).brightness ==
                                        //                     Brightness.dark
                                        //                 ? BorderStyle.solid
                                        //                 : BorderStyle.none),
                                        //     color: Theme.of(context)
                                        //         .inputDecorationTheme
                                        //         .fillColor),
                                        child: const Text('Join',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600))),
                                  )
                                ],
                              );
                            }),
                            // FollowLayout(
                            //     child: Text(
                            //       'Join',
                            //       style: TextStyle(fontWeight: FontWeight.w600),
                            //     ),
                            //     isFollowed: isPinned,
                            //     isPin: true,
                            //     height:30,
                            //     onChildPressed: () {},
                            //     onFollow: () =>
                            //         setState(() => isPinned = !isPinned))
                          ]),
                    ),
                  )
                ],
              );
            })),
      ),
    );
  }
}

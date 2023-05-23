import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/my_galaxy/leaderboard.dart';
import 'package:pulsar/post/post_screen.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class HighlightChallege extends StatefulWidget {
  final Challenge challenge;
  const HighlightChallege(this.challenge, {Key? key}) : super(key: key);

  @override
  State<HighlightChallege> createState() => _HighlightChallegeState();
}

class _HighlightChallegeState extends State<HighlightChallege> {
  late InteractionsSync interactionsSync;

  Challenge get challenge => widget.challenge;
  bool get isPinned => interactionsSync.isPinned(challenge);

  @override
  Widget build(BuildContext context) {
    interactionsSync = Provider.of<InteractionsSync>(context);
    return Section(
      title: local(context).newHighlight,
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
                    height: constraints.maxWidth > 480
                        ? 240
                        : constraints.maxWidth / 2,
                    decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(21),
                        ),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                challenge.cover.photo(context, max: 'medium')),
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
                                  .bodyLarge!
                                  .copyWith(fontSize: 19.5),
                              maxLines: 2,
                            ),
                            Text(
                              challenge.description ?? '',
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
                                    text: {
                                      true: local(context).pinned,
                                      false: local(context).pins(1)
                                    },
                                    onPressed: () => setState(() {
                                      challenge.pin(context,
                                          mode: isPinned
                                              ? RequestMethod.delete
                                              : RequestMethod.post,
                                          onNotify: () => setState(() {}));
                                    }),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (challenge.isJoined) {
                                        Navigator.of(context).push(myPageRoute(
                                            builder: (context) =>
                                                Leaderboard(challenge)));
                                      } else {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(myPageRoute(
                                                builder: (context) =>
                                                    PostProcess(
                                                        challenge: challenge)));
                                      }
                                    },
                                    child: Card(
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
                                          child: challenge.isJoined
                                              ? Icon(MyIcons.insights,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color)
                                              : Text(local(context).join,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600))),
                                    ),
                                  )
                                ],
                              );
                            }),
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

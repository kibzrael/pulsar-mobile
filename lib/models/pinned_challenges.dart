import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:pulsar/data/challenges.dart';

class PinnedChallenges extends StatefulWidget {
  const PinnedChallenges({Key? key}) : super(key: key);

  @override
  _PinnedChallengesState createState() => _PinnedChallengesState();
}

class _PinnedChallengesState extends State<PinnedChallenges>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ScrollController scrollController = ScrollController();

  List<Challenge> challenges = [
    urbanPortraits,
    litByFire,
    tapDance,
    afro,
    ballerinaArt,
    amazingFlowers,
    bestOfCairo,
    interiorChallenge,
    photographyChallenge,
    karaokeChallenge,
    actingChallenge,
    magicChallenge,
    comedyChallenge,
    makeupChallenge,
    bandChallenge,
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Section(
      title: "Challenges",
      child: Container(
        height: 125,
        margin: const EdgeInsets.only(top: 5),
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: challenges.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 15,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              Challenge challenge = challenges[index];
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(myPageRoute(
                        builder: (context) => ChallengePage(challenge)));
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        21,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Hero(
                          tag: '${challenge.id}',
                          child: Container(
                            height: 125,
                            width: 175,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(challenge
                                      .coverPhoto
                                      .photo(context, max: 'medium')),
                                  fit: BoxFit.cover),
                            ),
                            foregroundDecoration:
                                const BoxDecoration(color: Colors.black12),
                          ),
                        ),
                        Container(
                          height: 125,
                          width: 175,
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                challenge.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      fontSize: 21,
                                      color: Colors.white,
                                    ),
                                maxLines: 2,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                              // Container(
                              //   margin: const EdgeInsets.symmetric(
                              //       horizontal: 15, vertical: 7.5),
                              //   child: Row(
                              //     children: <Widget>[
                              //       Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 3),
                              //         child: Icon(
                              //           MyIcons.play,
                              //           color: Colors.white,
                              //           size: 15,
                              //         ),
                              //       ),
                              //       const Expanded(
                              //         flex: 2,
                              //         child: Text(
                              //           '3.14K',
                              //           style: TextStyle(
                              //               color: Colors.white, fontSize: 12),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 3),
                              //         child: Icon(
                              //           MyIcons.pin,
                              //           color: Colors.white,
                              //           size: 15,
                              //         ),
                              //       ),
                              //       const Expanded(
                              //         flex: 1,
                              //         child: Text(
                              //           '4.5K',
                              //           style: TextStyle(
                              //               color: Colors.white, fontSize: 12),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        Container(
                            height: 125,
                            width: 175,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.topLeft,
                            child: Transform.rotate(
                              angle: 45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(MyIcons.pin, color: Colors.white),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

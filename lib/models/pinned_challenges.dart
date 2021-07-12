import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:pulsar/data/challenges.dart';

class PinnedChallenges extends StatefulWidget {
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
        margin: EdgeInsets.only(top: 5),
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: challenges.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 15,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              Challenge challenge = challenges[index];
              return Padding(
                padding: EdgeInsets.only(left: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(myPageRoute(
                        builder: (context) => ChallengePage(challenge)));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
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
                              image: challenge.coverPhoto != null
                                  ? DecorationImage(
                                      image: AssetImage(challenge.coverPhoto!),
                                      fit: BoxFit.cover)
                                  : null,
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 175,
                          color: Colors.black26,
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${challenge.name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 7.5),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      child: Icon(
                                        MyIcons.play,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '3.14K',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      child: Icon(
                                        MyIcons.pin,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '4.5K',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: 125,
                            width: 175,
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.topLeft,
                            child: Transform.rotate(
                              angle: 45,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
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

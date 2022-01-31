import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/data/challenges.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class TrendingChallenges extends StatefulWidget {
  @override
  _TrendingChallengesState createState() => _TrendingChallengesState();
}

class _TrendingChallengesState extends State<TrendingChallenges> {
  List<Challenge> challenges = [danceChallenge, pubgtakeouts, codheadshot];

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Trending',
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return TrendingChallengeWidget(challenges[index]);
        },
      ),
    );
  }
}

class TrendingChallengeWidget extends StatefulWidget {
  final Challenge challenge;
  TrendingChallengeWidget(this.challenge);
  @override
  _TrendingChallengeWidgetState createState() =>
      _TrendingChallengeWidgetState();
}

class _TrendingChallengeWidgetState extends State<TrendingChallengeWidget> {
  Challenge get challenge => widget.challenge;

  bool isPinned = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => ChallengePage(challenge)));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        child: Row(children: [
          Container(
            height: 75,
            width: 90,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(15),
                ),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(challenge.coverPhoto!),
                    fit: BoxFit.cover)),
          ),
          Expanded(
            child: Text(challenge.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 19.5)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: FollowButton(
              height: 32,
              width: 72,
              text: {true: 'Pinned', false: 'Pin'},
              isFollowing: isPinned,
              onPressed: () => setState(() => isPinned = !isPinned),
            ),
          )
        ]),
      ),
    );
  }
}

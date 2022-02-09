import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/data/challenges.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class LatestChallenges extends StatefulWidget {
  const LatestChallenges({Key? key}) : super(key: key);

  @override
  _LatestChallengesState createState() => _LatestChallengesState();
}

class _LatestChallengesState extends State<LatestChallenges> {
  List<Challenge> challenges = [bestOfTokyo, pet, streetDance];

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Latest Challenges',
      child: ListView.builder(
          itemCount: challenges.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return LatestChallengeCard(challenges[index]);
          }),
    );
  }
}

class LatestChallengeCard extends StatefulWidget {
  final Challenge challenge;

  const LatestChallengeCard(this.challenge, {Key? key}) : super(key: key);
  @override
  _LatestChallengeCardState createState() => _LatestChallengeCardState();
}

class _LatestChallengeCardState extends State<LatestChallengeCard> {
  bool isJoined = false;

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      title: widget.challenge.name,
      subtitle: 'Category',
      onPressed: () {
        Navigator.of(context).push(
            myPageRoute(builder: (context) => ChallengePage(widget.challenge)));
      },
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            image: DecorationImage(
                image: AssetImage(widget.challenge.coverPhoto!),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(
          MyIcons.play,
          color: Colors.white,
          size: 30,
        ),
      ),
      trailingArrow: false,
      trailing: FollowButton(
        height: 30,
        width: 75,
        isFollowing: isJoined,
        text: const {true: 'Pinned', false: 'Pin'},
        onPressed: () {
          setState(() {
            isJoined = !isJoined;
          });
        },
      ),
    );
  }
}

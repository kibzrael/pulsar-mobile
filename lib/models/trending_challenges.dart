import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class TrendingChallenges extends StatefulWidget {
  final List<Map<String, dynamic>> challenges;
  const TrendingChallenges(this.challenges, {Key? key}) : super(key: key);

  @override
  State<TrendingChallenges> createState() => _TrendingChallengesState();
}

class _TrendingChallengesState extends State<TrendingChallenges> {
  @override
  Widget build(BuildContext context) {
    List<Challenge> challenges = [
      ...widget.challenges.map((e) => Challenge.fromJson(e))
    ];
    return Section(
      title: 'Top 3 Chart',
      child: ListView.builder(
        itemCount: challenges.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return TrendingChallengeWidget(challenges[index]);
        },
      ),
    );
  }
}

class TrendingChallengeWidget extends StatefulWidget {
  final Challenge challenge;
  const TrendingChallengeWidget(this.challenge, {Key? key}) : super(key: key);
  @override
  State<TrendingChallengeWidget> createState() =>
      _TrendingChallengeWidgetState();
}

class _TrendingChallengeWidgetState extends State<TrendingChallengeWidget> {
  late InteractionsSync interactionsSync;
  Challenge get challenge => widget.challenge;

  bool get isPinned => interactionsSync.isPinned(challenge);

  @override
  Widget build(BuildContext context) {
    interactionsSync = Provider.of<InteractionsSync>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => ChallengePage(challenge)));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(children: [
          ClipPath(
            clipper: ChallengeClipper(),
            child: Container(
              height: 90,
              width: 120,
              // margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(30),
                  ),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          challenge.cover.photo(context, max: 'medium')),
                      fit: BoxFit.cover)),
            ),
          ),
          Expanded(
            child: Text(
              challenge.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 19.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: FollowButton(
              height: 32,
              width: 72,
              text: const {true: 'Pinned', false: 'Pin'},
              isFollowing: isPinned,
              onPressed: () => setState(() {
                challenge.pin(context,
                    mode: isPinned ? RequestMethod.delete : RequestMethod.post,
                    onNotify: () => setState(() {}));
              }),
            ),
          )
        ]),
      ),
    );
  }
}

class ChallengeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 2 / 3, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

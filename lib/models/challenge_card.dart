import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/route.dart';

class ChallengeCard extends StatefulWidget {
  final Challenge challenge;

  ChallengeCard(this.challenge);

  @override
  _ChallengeCardState createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  late Challenge challenge;
  bool isPinned = false;

  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
  }

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).dividerColor,
        backgroundImage: CachedNetworkImageProvider(challenge.coverPhoto!),
      ),
      onPressed: () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => ChallengePage(challenge)));
      },
      title: '${challenge.name}',
      subtitle: '24K posts',
      trailingArrow: false,
      trailing: FollowButton(
        width: 72,
        height: 30,
        isFollowing: isPinned,
        text: {true: 'Pinned', false: 'Pin'},
        onPressed: () {
          setState(() {
            isPinned = !isPinned;
          });
        },
      ),
    );
  }
}

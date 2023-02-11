import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/route.dart';

class ChallengeCard extends StatefulWidget {
  final Challenge challenge;
  final Function()? onPressed;

  const ChallengeCard(this.challenge, {Key? key, this.onPressed})
      : super(key: key);

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  late InteractionsSync interactionsSync;

  late Challenge challenge;
  bool get isPinned => interactionsSync.isPinned(challenge);

  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
  }

  @override
  Widget build(BuildContext context) {
    interactionsSync = Provider.of<InteractionsSync>(context);
    return MyListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).dividerColor,
        backgroundImage: CachedNetworkImageProvider(challenge.cover.thumbnail),
      ),
      onPressed: widget.onPressed ??
          () {
            Navigator.of(context).push(
                myPageRoute(builder: (context) => ChallengePage(challenge)));
          },
      title: challenge.name,
      subtitle: '24K posts',
      trailingArrow: false,
      trailing: FollowButton(
        width: 72,
        height: 30,
        isFollowing: isPinned,
        text: const {true: 'Pinned', false: 'Pin'},
        onPressed: () {
          setState(() {
            challenge.pin(context,
                mode: isPinned ? RequestMethod.delete : RequestMethod.post,
                onNotify: () => setState(() {}));
          });
        },
      ),
    );
  }
}

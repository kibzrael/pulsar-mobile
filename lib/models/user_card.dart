import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class UserCard extends StatefulWidget {
  final User user;
  final bool trailing;
  final Function()? onPressed;

  const UserCard(this.user, {Key? key, this.trailing = true, this.onPressed})
      : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late UserProvider userProvider;
  late InteractionsSync interactionsSync;
  late User user;
  bool get isFollowing => interactionsSync.isFollowing(user);

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    interactionsSync = Provider.of<InteractionsSync>(context);
    userProvider = Provider.of<UserProvider>(context);
    return MyListTile(
      leading: ProfilePic(
        user.profilePic?.thumbnail,
        radius: 24,
      ),
      onPressed: widget.onPressed ??
          () {
            Navigator.of(context)
                .push(myPageRoute(builder: (context) => ProfilePage(user)));
          },
      title: '@${user.username}',
      subtitle: user.category,
      trailingArrow: !widget.trailing,
      trailing: userProvider.user.id == user.id || !widget.trailing
          ? null
          : FollowButton(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              isFollowing: isFollowing,
              onPressed: () {
                setState(() {
                  user.follow(context,
                      mode: isFollowing
                          ? RequestMethod.delete
                          : RequestMethod.post,
                      onNotify: () => setState(() {}));
                });
              },
            ),
    );
  }
}

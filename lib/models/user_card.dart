import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class UserCard extends StatefulWidget {
  final User user;

  UserCard(this.user);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late User user;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      leading: ProfilePic(
        user.profilePic,
        radius: 24,
      ),
      onPressed: () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => ProfilePage(user)));
      },
      title: '@${user.username}',
      subtitle: user.category,
      trailingArrow: false,
      trailing: FollowButton(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        isFollowing: isFollowing,
        onPressed: () {
          setState(() {
            isFollowing = !isFollowing;
          });
        },
      ),
    );
  }
}

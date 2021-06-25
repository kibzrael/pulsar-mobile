import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/widgets/follow_button.dart';

class InteractionNotificationCard extends StatefulWidget {
  final User user;
  InteractionNotificationCard(this.user);

  @override
  _InteractionNotificationCardState createState() =>
      _InteractionNotificationCardState();
}

class _InteractionNotificationCardState
    extends State<InteractionNotificationCard> {
  late User user;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).dividerColor,
                backgroundImage: AssetImage(user.profilePic),
              ),
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          '@${user.username}',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 16.5),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Yesterday',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    Text(
                      'Followed you',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ]),
            ),
            FollowButton(
              width: 75,
              height: 30,
              isFollowing: isFollowing,
              onPressed: () {
                setState(() {
                  isFollowing = !isFollowing;
                });
              },
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/widgets/action_button.dart';
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).dividerColor,
                backgroundImage: AssetImage(user.profilePic),
              ),
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15, right: 15),
                      child: Row(
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
                    ),
                    Text(
                      'Followed you',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: ActionButton(
                              title: 'Block',
                              height: 30,
                              onPressed: () {},
                              backgroundColor: Theme.of(context).disabledColor,
                              titleColor:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          FollowButton(
                            height: 30,
                            width: 100,
                            isFollowing: false,
                            onPressed: () {},
                          ),
                          Spacer(
                            flex: 3,
                          )
                        ],
                      ),
                    )
                  ]),
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:pulsar/classes/chat.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/message.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/messaging_screen.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class SpamMessagesCard extends StatefulWidget {
  final Message message;
  SpamMessagesCard(this.message);
  @override
  _SpamMessagesCardState createState() => _SpamMessagesCardState();
}

class _SpamMessagesCardState extends State<SpamMessagesCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(myPageRoute(
            builder: (context) => MessagingScreen(
                Chat([widget.message.user, tahlia], isSpam: true))));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 7.5, 5, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ProfilePic(
                  widget.message.user.profilePic,
                  radius: 30,
                ),
                if (isSelected)
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface),
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Center(
                          child: Icon(
                            MyIcons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.message.user.username,
                        overflow: TextOverflow.ellipsis,
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
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.message.message,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6,
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
                        SizedBox(
                          width: 100,
                          child: ActionButton(
                            title: 'Accept',
                            height: 30,
                            onPressed: () {},
                          ),
                        ),
                        Spacer(
                          flex: 3,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (!widget.message.isRead)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: secondaryGradient(begin: Alignment.topLeft)),
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white, fontSize: 13.5),
                ),
              )
          ],
        ),
      ),
    );
  }
}

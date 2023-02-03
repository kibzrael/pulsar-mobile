import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/chat.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/message.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/messaging_screen.dart';
import 'package:pulsar/providers/messages_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

class MessagesCard extends StatefulWidget {
  final Message message;
  const MessagesCard(this.message, {Key? key}) : super(key: key);
  @override
  State<MessagesCard> createState() => _MessagesCardState();
}

class _MessagesCardState extends State<MessagesCard> {
  MessagesProvider? messagesProvider;

  late Message message;

  bool? isSelected;

  @override
  void initState() {
    super.initState();
    message = widget.message;
  }

  void handleSelect() {
    if (isSelected!) {
      messagesProvider!.removeSelectedMessage(message);
    } else {
      messagesProvider!.addSelectedMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    messagesProvider = Provider.of<MessagesProvider>(context);
    bool selectMode = messagesProvider!.selectedMessages.isNotEmpty;

    isSelected = messagesProvider!.selectedMessages.any(
        (Message element) => element.user.username == message.user.username);

    return InkWell(
      onTap: () {
        if (selectMode) {
          handleSelect();
        } else {
          Navigator.of(context, rootNavigator: true).push(myPageRoute(
              builder: (context) =>
                  MessagingScreen(Chat([message.user, tahlia]))));
        }
      },
      onLongPress: handleSelect,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 7.5, 5, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ProfilePic(message.user.profilePic?.thumbnail, radius: 30),
                if (isSelected!)
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: accentGradient(),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Icon(
                              MyIcons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          message.user.username,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 16.5),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Yesterday',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      message.message,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            if (!message.isRead)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: accentGradient()),
                child: const Text(
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

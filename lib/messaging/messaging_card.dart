import 'package:flutter/material.dart';
import 'package:pulsar/classes/message.dart';
import 'package:pulsar/widgets/profile_pic.dart';

class MessagingCard extends StatefulWidget {
  /// to be removed
  final bool received;
  final Message message;
  MessagingCard({required this.received, required this.message});

  @override
  _MessagingCardState createState() => _MessagingCardState();
}

class _MessagingCardState extends State<MessagingCard> {
  late bool received;
  late Message message;

  @override
  void initState() {
    super.initState();
    received = widget.received;
    message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    Radius radius = Radius.circular(15);
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 7.5, 5, 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            received ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 16.5),
            child: received
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: ProfilePic(message.user.profilePic, radius: 16.5),
                  )
                : Container(),
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: message.attachment != null
                    ? MediaQuery.of(context).size.width * 0.65
                    : received
                        ? MediaQuery.of(context).size.width * 0.75
                        : MediaQuery.of(context).size.width * 0.85),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: received
                        ? Colors.transparent
                        : Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.all(radius),
                    border: received
                        ? Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1)
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      if (message.attachment != null)
                        Padding(
                          padding: EdgeInsets.all(1),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: radius, topRight: radius
                                  // put bottom if no text
                                  ),
                              child: Image.asset(message.attachment!)),
                        ),
                      Padding(
                        padding: EdgeInsets.all(7.5),
                        child: Text(
                          message.message,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 16.5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      '${message.time.hour}:${message.time.minute < 10 ? '0' : ''}${message.time.minute}',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontSize: 11),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/compose/recipient_card.dart';
import 'package:pulsar/widgets/section.dart';

class RecommendedChats extends StatefulWidget {
  final List<User> recipients;
  final Function onAdd;
  final Function onRemove;
  const RecommendedChats(
      {Key? key,
      required this.recipients,
      required this.onAdd,
      required this.onRemove})
      : super(key: key);
  @override
  State<RecommendedChats> createState() => _RecommendedChatsState();
}

class _RecommendedChatsState extends State<RecommendedChats> {
  @override
  Widget build(BuildContext context) {
    List<User> people = [
      tom,
      beth,
      melissa,
      thomas,
      nick,
      joy,
      lizzy,
      evah,
      joe,
      chris
    ];

    return Section(
      title: 'Recommended Chats',
      child: Flexible(
        child: ListView.builder(
            itemCount: people.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              bool isSelected = widget.recipients.contains(people[index]);
              return InkWell(
                  onTap: () {
                    if (isSelected) {
                      widget.onRemove(people[index]);
                    } else {
                      widget.onAdd(people[index]);
                    }
                  },
                  child: RecipientCard(people[index], isSelected: isSelected));
            }),
      ),
    );
  }
}

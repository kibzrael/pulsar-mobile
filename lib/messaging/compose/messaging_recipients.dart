import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/section.dart';

class MessagingRecipients extends StatefulWidget {
  final List<User> recipients;
  final Function(User user) onRemove;
  final Function() onClear;
  final ScrollController recipientsController;
  MessagingRecipients(
      {required this.recipients,
      required this.onRemove,
      required this.onClear,
      required this.recipientsController});
  @override
  _MessagingRecipientsState createState() => _MessagingRecipientsState();
}

class _MessagingRecipientsState extends State<MessagingRecipients> {
  List<User>? recipients;

  @override
  Widget build(BuildContext context) {
    recipients = widget.recipients;
    return Section(
      title: 'Members',
      trailing: InkWell(
          onTap: widget.onClear,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(MyIcons.clearAll),
          )),
      child: Container(
        constraints: BoxConstraints(maxHeight: 35),
        height: 35,
        alignment: Alignment.centerLeft,
        child: recipients!.length == 0
            ? Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Select users to chat with...',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontSize: 18),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: recipients!.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                reverse: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                controller: widget.recipientsController,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Chip(
                      elevation: 1,
                      label: Text('@${recipients![index].username}'),
                      deleteIcon: ShaderMask(
                          shaderCallback: (rect) =>
                              secondaryGradient(begin: Alignment.topLeft)
                                  .createShader(rect),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          )),
                      onDeleted: () {
                        setState(() {
                          widget.onRemove(recipients![index]);
                        });
                      },
                    ),
                  );
                }),
      ),
    );
  }
}

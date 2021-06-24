import 'package:flutter/material.dart';
import 'package:pulsar/classes/chat.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/compose/configure_group.dart';
import 'package:pulsar/messaging/messaging_screen.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_field.dart';
import 'package:pulsar/widgets/text_button.dart';
import 'package:pulsar/messaging/compose/messaging_recipients.dart';
import 'package:pulsar/messaging/compose/recommended_chats.dart';

class ComposeMessage extends StatefulWidget {
  @override
  _ComposeMessageState createState() => _ComposeMessageState();
}

class _ComposeMessageState extends State<ComposeMessage> {
  TextEditingController? searchController;

  ScrollController? recipientsController;

  String searchText = '';

  List<User> recipients = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController!.addListener(() {
      setState(() {
        searchText = searchController!.text;
      });
    });

    recipientsController = ScrollController();
  }

  @override
  void dispose() {
    searchController!.dispose();
    recipientsController!.dispose();
    super.dispose();
  }

  void addRecipient(User user) {
    setState(() {
      recipients.insert(0, user);
    });
    // if not effective
    // use WidgetsBinding.instance.addPostFrameCallback
    if (recipientsController!.hasClients)
      recipientsController!.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void removeRecipient(User user) {
    setState(() {
      recipients.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: SearchField(
            onChanged: (text) {},
            onSubmitted: (text) {},
            hintText: 'Search users...',
          ),
          titleSpacing: 0.0,
          actions: [
            MyTextButton(
              text: 'Chat',
              onPressed: () {
                if (recipients.length == 1) {
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                  Navigator.of(context, rootNavigator: true).push(myPageRoute(
                    builder: (context) => MessagingScreen(
                      Chat([tahlia, recipients[0]]),
                      isNew: true,
                    ),
                  ));
                } else if (recipients.length > 1) {
                  Navigator.of(context).push(myPageRoute(
                      builder: (context) => ConfigureGroup(recipients)));
                }
              },
              enabled: recipients.length >= 1,
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MessagingRecipients(
              recipients: recipients,
              onRemove: removeRecipient,
              recipientsController: recipientsController!,
            ),
            SizedBox(height: 12),
            Flexible(
              child: RecommendedChats(
                  recipients: recipients,
                  onAdd: addRecipient,
                  onRemove: removeRecipient),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pulsar/classes/chat.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/messaging_screen.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_field.dart';
import 'package:pulsar/widgets/text_button.dart';
import 'package:pulsar/messaging/compose/messaging_recipients.dart';
import 'package:pulsar/messaging/compose/recommended_chats.dart';

class ComposeMessage extends StatefulWidget {
  const ComposeMessage({Key? key}) : super(key: key);

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
    if (recipientsController!.hasClients) {
      recipientsController!.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void removeRecipient(User user) {
    setState(() {
      recipients.remove(user);
    });
  }

  clearRecipients() {
    setState(() {
      recipients.clear();
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
                Navigator.popUntil(context, ModalRoute.withName("/"));
                Navigator.of(context, rootNavigator: true).push(myPageRoute(
                  builder: (context) => MessagingScreen(
                    Chat([tahlia, ...recipients]),
                    isNew: true,
                  ),
                ));
              },
              enabled: recipients.isNotEmpty,
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MessagingRecipients(
              recipients: recipients,
              onRemove: removeRecipient,
              onClear: clearRecipients,
              recipientsController: recipientsController!,
            ),
            const SizedBox(height: 12),
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

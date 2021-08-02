import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/messaging/chats.dart';
import 'package:pulsar/messaging/highlight_users.dart';
import 'package:pulsar/messaging/search_messages.dart';
import 'package:pulsar/messaging/spam/spam_inbox.dart';
import 'package:pulsar/options/message_options.dart';
import 'package:pulsar/pages/home_page.dart';
import 'package:pulsar/providers/messages_provider.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  GlobalKey<NavigatorState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(3, () => key);
    return Scaffold(
      body: Navigator(
        key: key,
        initialRoute: '/',
        observers: [MyRouteObserver(context, 3)],
        onGenerateRoute: (settings) {
          return myPageRoute(
              settings: settings, builder: (context) => RootMessageScreen());
        },
      ),
    );
  }
}

class RootMessageScreen extends StatefulWidget {
  @override
  _RootMessageScreenState createState() => _RootMessageScreenState();
}

class _RootMessageScreenState extends State<RootMessageScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late ScrollController scrollController;

  late MessagesProvider messagesProvider;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  moreOnMessages() {
    openBottomSheet(context, (context) => MessageOptions());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BasicRootProvider rootPageProvider =
        Provider.of<BasicRootProvider>(context, listen: false);
    rootPageProvider.pageScrollControllers
        .putIfAbsent(3, () => scrollController);

    messagesProvider = Provider.of<MessagesProvider>(context);
    int numberSelected = messagesProvider.selectedMessages.length;
    bool selectMode = numberSelected >= 1;
    return Scaffold(
      appBar: AppBar(
        leading: selectMode
            ? IconButton(
                icon: Icon(
                  MyIcons.close,
                ),
                onPressed: messagesProvider.clearMessages,
              )
            : IconButton(
                icon: Icon(MyIcons.spam),
                onPressed: () {
                  Navigator.of(context)
                      .push(myPageRoute(builder: (context) => SpamInbox()));
                },
              ),
        titleSpacing: 0.0,
        centerTitle: true,
        title: selectMode
            ? Text('$numberSelected selected')
            : OpenContainer(
                openElevation: 0.0,
                closedElevation: 0.0,
                transitionDuration: Duration(milliseconds: 500),
                closedColor: Colors.transparent,
                closedBuilder: (context, open) {
                  return Hero(
                    tag: 'searchMessages',
                    child: SearchInput(
                      text: 'Search Messages',
                      onPressed: open,
                    ),
                  );
                },
                openBuilder: (context, action) => SearchMessages(),
              ),
        actions: [
          selectMode
              ? IconButton(icon: Icon(MyIcons.more), onPressed: moreOnMessages)
              : IconButton(icon: Icon(MyIcons.sort), onPressed: () {})
        ],
        bottom: PreferredSize(
            child: HighlightUsers(),
            preferredSize: Size(MediaQuery.of(context).size.width, 100)),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        height: double.infinity,
        child: Chats(
          scrollController: scrollController,
        ),
      ),
    );
  }
}

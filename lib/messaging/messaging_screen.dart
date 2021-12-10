import 'package:flutter/material.dart';
import 'package:pulsar/classes/chat.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/classes/message.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/messaging/messaging_card.dart';
import 'package:pulsar/options/chat.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/text_input.dart';

class MessagingScreen extends StatefulWidget {
  final Chat chat;
  final bool isNew;
  MessagingScreen(this.chat, {this.isNew = false});
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ScrollController? scrollController;
  TextEditingController? messageController;

  bool isTyping = false;
  String message = '';

  late Chat chat;

  User? user;
  String? name;

  bool isSearching = true;
  bool canLoadMore = true;

  List<Message> messagesList = [];

  @override
  void initState() {
    super.initState();
    chat = widget.chat;
    if (!chat.isGroup) {
      user = chat.receipient(tahlia)!;
    } else {
      name = chat.name;
    }
    fetchMessages();
    scrollController = ScrollController();
    scrollController!.addListener(scrollListener);
    messageController = TextEditingController();
  }

  scrollListener() {
    if (scrollController!.position.pixels ==
            scrollController!.position.maxScrollExtent &&
        !isSearching &&
        canLoadMore) {
      fetchMoreMessages();
    }
  }

  @override
  void dispose() {
    scrollController!.removeListener(scrollListener);
    scrollController!.dispose();
    messageController!.dispose();
    super.dispose();
  }

  fetchMessages() async {
    await Future.delayed(Duration(seconds: 2));
    if (!widget.isNew) {
      for (String testMessage in testMessages) {
        User sender = chat.isGroup ? chat.members.first : user!;
        messagesList.add(Message(
            message: testMessage,
            user: sender,
            time: DateTime.now()
                .subtract(Duration(days: (messagesList.length / 4).floor())),
            attachment: messagesList.length % 7 == 0
                ? 'assets/challenges/adventure.jpg'
                : null));
      }
    }
    if (mounted)
      setState(() {
        isSearching = false;
        if (widget.isNew) {
          canLoadMore = false;
        }
      });
  }

  fetchMoreMessages() async {
    setState(() {
      isSearching = true;
    });
    await Future.delayed(Duration(seconds: 2));
    messagesList = [...messagesList.reversed, ...messagesList];

    if (mounted)
      setState(() {
        isSearching = false;
        if (messagesList.length > 30) canLoadMore = false;
      });
  }

  moreOnChats() {
    openBottomSheet(context, (context) => ChatOptions());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            actions: <Widget>[
              IconButton(icon: Icon(MyIcons.more), onPressed: moreOnChats)
            ],
            title: InkWell(
              onTap: () {
                if (!chat.isGroup)
                  Navigator.of(context).push(
                      myPageRoute(builder: (context) => ProfilePage(user!)));
              },
              child: Text(
                '@${chat.isGroup ? name! : user!.username}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (isSearching && messagesList.length < 1)
                  MyProgressIndicator(),
                Flexible(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount:
                        isSearching && messagesList.length >= 1 && canLoadMore
                            ? messagesList.length + 1
                            : messagesList.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == messagesList.length) {
                        return Center(
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 30, maxHeight: 30),
                            margin: EdgeInsets.all(5.0),
                            height: 30,
                            width: 30,
                            child: Card(
                              elevation: 1.5,
                              shape: CircleBorder(),
                              margin: EdgeInsets.zero,
                              color: Theme.of(context).canvasColor,
                              child: MyProgressIndicator(
                                size: 20,
                                margin: EdgeInsets.all(5),
                              ),
                            ),
                          ),
                        );
                      }

                      List<Message> messages = messagesList.reversed.toList();

                      Message thisMessage = messages[index];
                      Message? previousMessage =
                          (index - 1) < 0 ? null : messages[index - 1];
                      DateTime previousDate = previousMessage == null
                          ? DateTime.now()
                          : previousMessage.time;

                      Widget returnMessage() {
                        if (index % 2 == 0) {
                          return MessagingCard(
                            received: true,
                            message: messages[index],
                          );
                        } else {
                          return MessagingCard(
                              received: false, message: messages[index]);
                        }
                      }

                      if (thisMessage.time.day != previousDate.day) {
                        DateTime markerDate = previousDate;
                        previousDate = thisMessage.time;
                        return Column(
                          children: [
                            returnMessage(),
                            if (previousMessage != null) dateMarker(markerDate),
                          ],
                        );
                      }
                      previousDate = thisMessage.time;

                      return returnMessage();
                    },
                  ),
                ),
                if (widget.chat.isSpam) Divider(),
                if (widget.chat.isSpam) spamOptions(),
                if (!widget.chat.isSpam)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Row(
                      children: [
                        Flexible(
                          child: MyTextInput(
                            controller: messageController,
                            hintText: 'Write a message...',
                            maxLines: 7,
                            height: null,
                            padding: EdgeInsets.fromLTRB(
                                4, 2, message.length < 1 ? 4 : 8, 2),
                            prefix: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(MyIcons.attatchment),
                            ),
                            onChanged: (text) {
                              setState(() {
                                message = text;
                                if (text.length > 0 && text.trim() == '') {
                                  isTyping = false;
                                } else {
                                  isTyping = true;
                                }
                              });
                            },
                            onSubmitted: (text) {},
                            suffix: Row(
                              children: [
                                if (message.length < 1)
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(MyIcons.camera),
                                  ),
                                if (message.length < 1)
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(MyIcons.mic),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            if (message.length > 0 && message.trim() != '') {
                              setState(() {
                                messagesList.add(Message(
                                    message: message.trim(),
                                    user: tahlia,
                                    time: DateTime.now()));
                                messageController!.text = '';
                                message = '';
                                isTyping = false;
                              });
                            }
                          },
                          child: Card(
                            margin: EdgeInsets.all(2),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(21)),
                            child: Container(
                              child: Icon(
                                MyIcons.send,
                                color: Colors.white,
                              ),
                              height: 42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primaryVariant
                                  ])),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )),
    );
  }

  Widget dateMarker(DateTime date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30)),
      child: Text('${date.day}/${date.month}/${date.year}'),
    );
  }

  Widget spamOptions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Spam Messenger?',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 5),
          Text(
            'This user is not among your accepted messengers.\nAccept if your interested in chatting.\nBlock if it is a disturbance.',
            style:
                Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 13.5),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Flexible(
                  child: ActionButton(
                    title: 'Block',
                    height: 37.5,
                    backgroundColor: Theme.of(context).disabledColor,
                    titleColor: Theme.of(context).textTheme.bodyText2!.color,
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: ActionButton(
                    title: 'Accept',
                    height: 37.5,
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<String> testMessages = [
  'Hi',
  'Hi2',
  'Hows you',
  'am fine jus chillin',
  'Me too, i have to admit, home may be boring sometimes',
  'Yeah sure!!! it is jus tv all day, today, tomorrow and the day after',
  'U free this weeknd?',
  'Kinda why?',
  'I was thinking maybe we could hang out, my parents are out of town',
  'You mean at your house!!!',
  'Yeah',
  'Ok i think i will make it. See you then.'
];

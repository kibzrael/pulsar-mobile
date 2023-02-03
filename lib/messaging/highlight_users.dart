import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/messaging/compose/compose_message.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';

enum HighlightMode {
  recommended,

  favorite,

  frequent,
}

Map<HighlightMode, String> highlightTitles = {
  HighlightMode.recommended: 'Recommended Users',
  HighlightMode.frequent: 'Frequent Chats',
  HighlightMode.favorite: 'Favorite Users'
};

class HighlightUsers extends StatefulWidget {
  const HighlightUsers({Key? key}) : super(key: key);

  @override
  State<HighlightUsers> createState() => _HighlightUsersState();
}

class _HighlightUsersState extends State<HighlightUsers> {
  List<User> users = [beth, nick, lizzy, evah, thomas];

  HighlightMode? highlightMode;

  @override
  void initState() {
    super.initState();
    highlightMode = HighlightMode.favorite;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      height: 100,
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: ListView.builder(
          itemCount: users.length + 1,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(myPageRoute(
                      builder: (context) => const ComposeMessage()));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  constraints:
                      const BoxConstraints(minWidth: 90, maxWidth: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: const CircleBorder(),
                        margin: const EdgeInsets.all(4),
                        child: SizedBox(
                          width: 52,
                          height: 52,
                          child: ShaderMask(
                            shaderCallback: (rect) =>
                                accentGradient().createShader(rect),
                            child: Icon(
                              MyIcons.add,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Compose',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16.5),
                      )
                    ],
                  ),
                ),
              );
            } else {
              index = index - 1;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                constraints: const BoxConstraints(minWidth: 90, maxWidth: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        ProfilePic(users[index].profilePic?.thumbnail,
                            radius: 30),
                        // if (online)
                        //   Container(
                        //     padding: EdgeInsets.all(2.5),
                        //     decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Theme.of(context).appBarTheme.color),
                        //     child: CircleAvatar(
                        //       radius: 7,
                        //       backgroundColor: Theme.of(context).accentColor,
                        //     ),
                        //   )
                      ],
                    ),
                    Text(
                      users[index].username,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 16.5),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}

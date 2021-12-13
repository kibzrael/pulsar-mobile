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
  @override
  _HighlightUsersState createState() => _HighlightUsersState();
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
      decoration: BoxDecoration(),
      height: 100,
      padding: EdgeInsets.only(bottom: 5, top: 5),
      child: ListView.builder(
          itemCount: users.length + 1,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      myPageRoute(builder: (context) => ComposeMessage()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  constraints: BoxConstraints(minWidth: 90, maxWidth: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Card(
                        shape: CircleBorder(),
                        margin: EdgeInsets.all(4),
                        child: Container(
                          width: 52,
                          height: 52,
                          child: ShaderMask(
                            shaderCallback: (rect) =>
                                secondaryGradient(begin: Alignment.topLeft)
                                    .createShader(rect),
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
                            .bodyText1
                            ?.copyWith(fontSize: 16.5),
                      )
                    ],
                  ),
                ),
              );
            } else {
              index = index - 1;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                constraints: BoxConstraints(minWidth: 90, maxWidth: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        ProfilePic(users[index].profilePic, radius: 30),
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
                          .bodyText1
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

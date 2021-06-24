import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/models/user_card.dart';
import 'package:pulsar/widgets/ads.dart';
import 'package:pulsar/widgets/section.dart';

class InteractionScreen extends StatefulWidget {
  final User? user;
  final Challenge? challenge;

  InteractionScreen({
    this.user,
    this.challenge,
  });

  @override
  _InteractionScreenState createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  User? user;
  Challenge? challenge;

  late bool isUser;

  List<User> interactions = [
    melissa,
    rael,
    nick,
    joe,
    tom,
    beth,
    thomas,
    joy,
    lizzy,
    evah,
    chris
  ];

  @override
  void initState() {
    super.initState();
    user = widget.user;
    challenge = widget.challenge;
    isUser = user != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('@${isUser ? user!.username : challenge!.name}'),
      ),
      body: Section(
        title: isUser ? 'Followers' : 'Pins',
        trailing: Text(
          '22K',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        child: Flexible(
            child: ListView.builder(
                itemCount: interactions.length + 1,
                itemBuilder: (context, index) {
                  if (interactions.isNotEmpty) {
                    if (index == 5) {
                      return BannerAd();
                    }
                    if (index > 5) {
                      return UserCard(interactions[index - 1]);
                    }
                    return UserCard(interactions[index]);
                  }
                  return Container();
                })),
      ),
    );
  }
}

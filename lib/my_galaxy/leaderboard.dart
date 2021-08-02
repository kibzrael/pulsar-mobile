import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:pulsar/ads/banner_ad.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/section.dart';

class Leaderboard extends StatefulWidget {
  final Challenge challenge;
  Leaderboard(this.challenge);
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late Challenge challenge;

  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text('Leaderboard'),
          actions: [IconButton(onPressed: () {}, icon: Icon(MyIcons.info))],
        ),
        body: NestedScrollView(
          controller: controller,
          headerSliverBuilder: (context, f) {
            return [
              SliverList(
                  delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        winnersProfile(2, lynn),
                        winnersProfile(1, tahlia),
                        winnersProfile(3, kinjaz),
                      ],
                    ),
                  ),
                  MyBannerAd(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: SectionTitle(
                      title: '${challenge.name}',
                      trailing: Text(
                        '12K posts',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                ],
              )),
            ];
          },
          innerScrollPositionKeyBuilder: () {
            return Key('Scroll1');
          },
          body: Column(
            children: [
              MyListTile(
                title: 'You',
                subtitle: 'Current Position',
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/old_logo.jpg'),
                  radius: 21,
                ),
                trailingText: 'N/A',
                flexRatio: [4, 1],
              ),
              Expanded(
                child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: NestedScrollViewInnerScrollPositionKeyWidget(
                        Key('Scroll1'),
                        ListView.builder(
                            itemCount: allUsers.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              User user = allUsers[index];
                              return MyListTile(
                                title: '@${user.username}',
                                subtitle: user.category,
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(user.profilePic),
                                  radius: 21,
                                ),
                                trailing: Card(
                                  shape: CircleBorder(),
                                  child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${index + 4}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      )),
                                ),
                                trailingArrow: false,
                                flexRatio: [4, 1],
                              );
                            }))),
              ),
            ],
          ),
        ));
  }

  Widget winnersProfile(int pos, User user) {
    double width = MediaQuery.of(context).size.width - 50;
    double containerWidth = (width / 3) + (pos == 1 ? 20 : 0);
    double profileWidth =
        pos == 1 ? containerWidth : containerWidth - (pos == 2 ? 15 : 21);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                width: profileWidth,
                height: profileWidth,
                margin: EdgeInsets.only(bottom: 10 - pos.toDouble()),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    image: DecorationImage(
                        image: AssetImage(user.profilePic), fit: BoxFit.cover),
                    border: Border.all(
                        width: 3, color: Theme.of(context).accentColor))),
            Container(
              width: 28 - pos.toDouble(),
              height: 28 - pos.toDouble(),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).buttonColor
                ]),
              ),
              child: Text(
                pos.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18 - pos.toDouble(),
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        SizedBox(height: 5),
        Text(
          '@${user.username}',
          style:
              Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 13.5),
          maxLines: 1,
        )
      ],
    );
  }
}

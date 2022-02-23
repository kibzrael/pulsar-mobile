import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide NestedScrollView;

import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/info/info.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/widgets/route.dart';

class Leaderboard extends StatefulWidget {
  final Challenge challenge;
  const Leaderboard(this.challenge, {Key? key}) : super(key: key);
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

  Future<bool> onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          actions: [
            IconButton(
                onPressed: () {
                  openBottomSheet(context, (context) => const InfoSheet());
                },
                icon: Icon(MyIcons.info))
          ],
        ),
        body: const NotImplementedError()
        // LayoutBuilder(builder: (context, constraints) {
        //   return NestedScrollViewRefreshIndicator(
        //       onRefresh: onRefresh,
        //       child: ExtendedNestedScrollView(
        //         controller: controller,

        //         headerSliverBuilder: (context, f) {
        //           return [
        //             SliverList(
        //                 delegate: SliverChildListDelegate(
        //               [
        //                 // SizedBox(
        //                 //   height: displacement.value * 75,
        //                 //   width: double.infinity,
        //                 //   child: Container(
        //                 //     alignment: Alignment.center,
        //                 //     width: double.infinity,
        //                 //     color: Theme.of(context).colorScheme.surface,
        //                 //     child: SingleChildScrollView(
        //                 //       child: Padding(
        //                 //         padding: EdgeInsets.all(8),
        //                 //         child: CircularProgressIndicator(
        //                 //           value: show ? null : displacement.value,
        //                 //           strokeWidth: 1,
        //                 //         ),
        //                 //       ),
        //                 //     ),
        //                 //   ),
        //                 // ),
        //                 Container(
        //                   padding: const EdgeInsets.symmetric(
        //                       horizontal: 15, vertical: 12),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     crossAxisAlignment: CrossAxisAlignment.end,
        //                     children: [
        //                       winnersProfile(2, lynn),
        //                       winnersProfile(1, tahlia),
        //                       winnersProfile(3, kinjaz),
        //                     ],
        //                   ),
        //                 ),
        //                 const ListTileAd(),
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 4),
        //                   child: SectionTitle(
        //                     title: challenge.name,
        //                     trailing: Text(
        //                       '12K posts',
        //                       style: Theme.of(context).textTheme.subtitle2,
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             )),
        //           ];
        //         },
        //         // innerScrollPositionKeyBuilder: () {
        //         //   return Key('Scroll1');
        //         // },
        //         onlyOneScrollInBody: true,
        //         body: Column(
        //           children: [
        //             const MyListTile(
        //               title: 'You',
        //               subtitle: 'Current Position',
        //               leading: CircleAvatar(
        //                 backgroundImage: AssetImage('assets/old_logo.jpg'),
        //                 radius: 21,
        //               ),
        //               trailingText: 'N/A',
        //               flexRatio: [4, 1],
        //             ),
        //             Expanded(
        //               child: Container(
        //                   color: Theme.of(context).colorScheme.surface,
        //                   child: ListView.builder(
        //                       itemCount: allUsers.length,
        //                       shrinkWrap: true,
        //                       itemBuilder: (context, index) {
        //                         User user = allUsers[index];
        //                         return MyListTile(
        //                           title: '@${user.username}',
        //                           subtitle: user.category,
        //                           onPressed: () {
        //                             Navigator.of(context).push(myPageRoute(
        //                                 builder: (context) =>
        //                                     ProfilePage(user)));
        //                           },
        //                           leading: ProfilePic(
        //                             user.profilePic?.thumbnail,
        //                             radius: 21,
        //                           ),
        //                           trailing: Card(
        //                             shape: const CircleBorder(),
        //                             child: Padding(
        //                                 padding: const EdgeInsets.all(8),
        //                                 child: Text(
        //                                   '${index + 4}',
        //                                   style: Theme.of(context)
        //                                       .textTheme
        //                                       .bodyText1,
        //                                 )),
        //                           ),
        //                           trailingArrow: false,
        //                           flexRatio: const [4, 1],
        //                         );
        //                       })),
        //             ),
        //           ],
        //         ),
        //       ));
        // })
        );
  }

  Widget winnersProfile(int pos, User user) {
    double width = MediaQuery.of(context).size.width - 50;
    double containerWidth = (width / 3) + (pos == 1 ? 20 : 0);
    double profileWidth =
        pos == 1 ? containerWidth : containerWidth - (pos == 2 ? 15 : 21);

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => ProfilePage(user)));
      },
      child: Column(
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
                          image: CachedNetworkImageProvider(
                              user.profilePic!.thumbnail),
                          fit: BoxFit.cover),
                      border: Border.all(
                          width: 3,
                          color: Theme.of(context).colorScheme.secondary))),
              Container(
                width: 28 - pos.toDouble(),
                height: 28 - pos.toDouble(),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer
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
          const SizedBox(height: 5),
          Text(
            '@${user.username}',
            style:
                Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 13.5),
            maxLines: 1,
          )
        ],
      ),
    );
  }
}

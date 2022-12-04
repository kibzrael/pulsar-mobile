import 'dart:convert';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:provider/provider.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:http/http.dart' as http;

import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/functions/dynamic_count.dart';
import 'package:pulsar/info/info.dart';
import 'package:pulsar/info/leaderboard.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/profile_page.dart';
import 'package:pulsar/urls/challenge.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/refresh_indicator.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class Leaderboard extends StatefulWidget {
  final Challenge challenge;
  const Leaderboard(this.challenge, {Key? key}) : super(key: key);
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late Challenge challenge;

  late UserProvider userProvider;

  late ScrollController controller;

  int? you;

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

  Future<List<Map<String, dynamic>>> fetchData(int index) async {
    List<Map<String, dynamic>> results = [];
    String url = getUrl(ChallengeUrls.leaderboard(challenge));
    Uri uri = Uri.parse(url);
    http.Response response = await http
        .get(uri, headers: {'Authorization': userProvider.user.token ?? ''});
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      you = data['you'];
      setState(() {});
      results = [...List<Map<String, dynamic>>.from(data['data'])];
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          actions: [
            IconButton(
                onPressed: () {
                  openBottomSheet(
                      context, (context) => InfoSheet(leaderboardInfo));
                },
                icon: Icon(MyIcons.info))
          ],
        ),
        body: RecyclerView(
            target: fetchData,
            itemBuilder: (context, snapshot) {
              List<Map<String, dynamic>> snapshotData = snapshot.data;
              List<User> users = [...snapshotData.map((e) => User.fromJson(e))];
              int usersLength = users.length > 3 ? users.length - 3 : 0;
              return snapshotData.isEmpty
                  ? snapshot.isLoading ?? true
                      ? const Align(
                          alignment: Alignment.center,
                          child: MyProgressIndicator(),
                        )
                      : snapshot.errorLoading
                          ? snapshot.noData
                              ? const NoPosts(
                                  alignment: Alignment.center,
                                  message: "There are no participants")
                              : Center(
                                  child: NetworkError(
                                      onRetry: snapshot.refreshCallback))
                          : Container()
                  : LayoutBuilder(builder: (context, constraints) {
                      return NestedScrollViewRefreshIndicator(
                          onRefresh: snapshot.refreshCallback,
                          child: ExtendedNestedScrollView(
                            controller: controller,

                            headerSliverBuilder: (context, f) {
                              return [
                                SliverList(
                                    delegate: SliverChildListDelegate(
                                  [
                                    // SizedBox(
                                    //   height: displacement.value * 75,
                                    //   width: double.infinity,
                                    //   child: Container(
                                    //     alignment: Alignment.center,
                                    //     width: double.infinity,
                                    //     color: Theme.of(context).colorScheme.surface,
                                    //     child: SingleChildScrollView(
                                    //       child: Padding(
                                    //         padding: EdgeInsets.all(8),
                                    //         child: CircularProgressIndicator(
                                    //           value: show ? null : displacement.value,
                                    //           strokeWidth: 1,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          winnersProfile(
                                              2,
                                              users.length > 1
                                                  ? users[1]
                                                  : null),
                                          winnersProfile(
                                              1,
                                              users.isNotEmpty
                                                  ? users[0]
                                                  : null),
                                          winnersProfile(
                                              3,
                                              users.length > 2
                                                  ? users[2]
                                                  : null),
                                        ],
                                      ),
                                    ),
                                    const ListTileAd(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: SectionTitle(
                                        title: challenge.name,
                                        trailing: Text(
                                          '${roundCount(challenge.posts)} post${challenge.posts == 1 ? '' : 's'}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ];
                            },
                            // innerScrollPositionKeyBuilder: () {
                            //   return Key('Scroll1');
                            // },
                            onlyOneScrollInBody: true,
                            body: Column(
                              children: [
                                MyListTile(
                                  title: 'You',
                                  subtitle: 'Current Position',
                                  leading: ProfilePic(
                                    userProvider.user.profilePic?.thumbnail,
                                    radius: 21,
                                  ),
                                  trailingText: you?.toString() ?? 'N/A',
                                  flexRatio: const [4, 1],
                                ),
                                Expanded(
                                  child: Container(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      child: ListView.builder(
                                          itemCount: usersLength,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            User user = users[index + 3];
                                            return MyListTile(
                                              title: '@${user.username}',
                                              subtitle: user.category,
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    myPageRoute(
                                                        builder: (context) =>
                                                            ProfilePage(user)));
                                              },
                                              leading: ProfilePic(
                                                user.profilePic?.thumbnail,
                                                radius: 21,
                                              ),
                                              trailing: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 1),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: Text(
                                                      '${index + 4}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    )),
                                              ),
                                              trailingArrow: false,
                                              flexRatio: const [4, 1],
                                            );
                                          })),
                                ),
                              ],
                            ),
                          ));
                    });
            }));
  }

  Widget winnersProfile(int pos, User? user) {
    double width = MediaQuery.of(context).size.width - 50;
    double containerWidth = (width / 3) + (pos == 1 ? 20 : 0);
    double profileWidth =
        pos == 1 ? containerWidth : containerWidth - (pos == 2 ? 15 : 21);
    double bottomPadding = (3 - pos) * 40;
    return InkWell(
      onTap: () {
        if (user != null) {
          Navigator.of(context)
              .push(myPageRoute(builder: (context) => ProfilePage(user)));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10 - pos.toDouble()),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: pos == 1
                        ? accentGradient()
                        : pos == 2
                            ? primaryGradient()
                            : secondaryGradient()),
                child: Container(
                    width: profileWidth,
                    height: profileWidth,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    child: ProfilePic(
                        user?.profilePic?.photo(context, max: 'medium'),
                        radius: profileWidth / 2)),
              ),
              Container(
                width: 36 - pos.toDouble(),
                height: 36 - pos.toDouble(),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 5),
                    gradient: pos == 1
                        ? accentGradient()
                        : pos == 2
                            ? primaryGradient()
                            : secondaryGradient()),
                child: Text(
                  pos.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16 - pos.toDouble(),
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          if (user != null) const SizedBox(height: 5),
          if (user != null)
            Text(
              user.username,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontSize: 13.5),
              maxLines: 1,
            ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}

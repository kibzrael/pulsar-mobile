import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:pulsar/ads/banner_ad.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/models/follow_layout.dart';
import 'package:pulsar/models/profile_stats.dart';
import 'package:pulsar/my_galaxy/leaderboard.dart';
import 'package:pulsar/my_galaxy/prizes.dart';
import 'package:pulsar/my_galaxy/rules.dart';
import 'package:pulsar/options/challenge_options.dart';
import 'package:pulsar/post/post_screen.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/secondary_pages.dart/interaction_screen.dart';
import 'package:pulsar/secondary_pages.dart/grid_posts.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/refresh_indicator.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/classes/challenge.dart';

class ChallengePage extends StatefulWidget {
  final Challenge challenge;
  ChallengePage(this.challenge);
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  ScrollController? scrollController;

  double scrollPosition = 0;

  bool isFollowed = false;

  late Challenge challenge;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    scrollController = ScrollController();
    scrollController!.addListener(scrollListener);
    challenge = widget.challenge;
  }

  scrollListener() {
    setState(() {
      scrollPosition = scrollController!.offset;
    });
  }

  moreOnChallenge() {
    openBottomSheet(context, (context) => ChallengeOptions(challenge));
  }

  Future<bool> onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget option(
            {required IconData icon,
            required String text,
            required Function() onPressed}) =>
        Container(
          width: (MediaQuery.of(context).size.width / 3) - 30,
          child: InkWell(
            onTap: onPressed,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: CircleBorder(),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 36),
                  ),
                ),
                SizedBox(height: 5),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 15),
                    )),
              ],
            ),
          ),
        );

    return Scaffold(
        body: NestedScrollViewRefreshIndicator(
      onRefresh: onRefresh,
      child: ExtendedNestedScrollView(
        floatHeaderSlivers: true,
        controller: scrollController,
        pinnedHeaderSliverHeightBuilder: () =>
            (MediaQuery.of(context).padding.top + kToolbarHeight),
        headerSliverBuilder: (context, bool) {
          double opacity = scrollPosition / (200 - kToolbarHeight);
          double padding = scrollPosition > 45 ? 45 : scrollPosition;
          return [
            Theme(
              data: Theme.of(context).brightness == Brightness.dark
                  ? darkTheme
                  : scrollPosition < 130
                      ? darkTheme
                      : lightTheme,
              child: SliverAppBar(
                floating: false,
                titleSpacing: 0.0,
                elevation: 0.0,
                pinned: true,
                backgroundColor: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(opacity < 1 ? opacity : 1),
                expandedHeight: 200,
                actions: [
                  // Container(
                  //   margin:
                  //       EdgeInsets.symmetric(vertical: (kToolbarHeight - 30) / 2),
                  //   child: SecondaryButton(text: 'Tutorial'),
                  // ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    iconSize: 30,
                    onPressed: moreOnChallenge,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsetsDirectional.only(
                      start: 56, bottom: 17.5, end: padding),
                  title: Text(
                    '${challenge.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Stack(
                    children: [
                      Positioned.fill(
                          child: Hero(
                        tag: '${challenge.id}',
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              image: challenge.coverPhoto != null
                                  ? DecorationImage(
                                      image: AssetImage(challenge.coverPhoto!),
                                      fit: BoxFit.cover)
                                  : null),
                        ),
                      )),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                0.175,
                                0.35,
                                0.75,
                                1.0
                              ],
                                  colors: [
                                Colors.black12,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black12,
                              ])),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: MyBannerAd(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ProfileStats(
                    isPin: true,
                    pins: 11700,
                    pinsOnPressed: () {
                      Navigator.of(context).push(myPageRoute(
                          builder: (context) => InteractionScreen(
                                challenge: challenge,
                              )));
                    },
                    postOnPressed: () {
                      scrollController!.animateTo(
                          scrollController!.position.maxScrollExtent,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.ease);
                    },
                    posts: 620000,
                  ),
                ),
                if (challenge.description != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 5),
                    child: Text(
                      challenge.description!,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                FollowLayout(
                    child: Text(
                      'Join',
                      style: TextStyle(
                          //color: Theme.of(context).buttonColor,
                          fontWeight: FontWeight.w600),
                    ),
                    isFollowed: isFollowed,
                    isPin: true,
                    onChildPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                          myPageRoute(
                              builder: (context) =>
                                  PostProcess(challenge: challenge)));
                    },
                    onFollow: () {
                      setState(() {
                        isFollowed = !isFollowed;
                      });
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      option(
                          icon: MyIcons.rules,
                          text: 'Rules',
                          onPressed: () {
                            Navigator.push(
                                context,
                                myPageRoute(
                                    builder: (context) => ChallengeRules(
                                        challenge,
                                        rules: challenge.description ?? '')));
                          }),
                      option(
                          icon: MyIcons.prize,
                          text: 'Prizes',
                          onPressed: () {
                            Navigator.push(
                                context,
                                myPageRoute(
                                    builder: (context) => ChallengePrizes()));
                          }),
                      option(
                          icon: MyIcons.leaderboard,
                          text: 'Leaderboard',
                          onPressed: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) => Leaderboard(challenge)));
                          }),
                    ],
                  ),
                ),
              ],
            ))
          ];
        },
        onlyOneScrollInBody: false,
        body: Column(
          children: [
            TabBar(
              controller: tabController,
              indicator: BoxDecoration(),
              unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
              labelPadding: EdgeInsets.zero,
              tabs: <Widget>[
                CustomTab('Recent'),
                CustomTab(
                  'Trending',
                  divider: false,
                )
              ],
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                constraints: BoxConstraints(minHeight: 100),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    GridPosts(lynn),
                    GridPosts(lynn),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

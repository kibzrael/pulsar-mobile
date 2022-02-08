import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pulsar/ads/challenges_ad.dart';

import 'package:pulsar/basic_root.dart';
import 'package:pulsar/data/challenges.dart';
import 'package:pulsar/models/discover_challenges.dart';
import 'package:pulsar/models/highlight_challenge.dart';
import 'package:pulsar/models/pinned_challenges.dart';
import 'package:pulsar/models/trending_challenges.dart';
import 'package:pulsar/my_galaxy/search/search_screen.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/widgets/refresh_indicator.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';

class ChallengesPage extends StatefulWidget {
  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  GlobalKey<NavigatorState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(1, () => key);
    return Navigator(
      key: key,
      initialRoute: '/',
      observers: [MyRouteObserver(context, 1)],
      onGenerateRoute: (settings) {
        return myPageRoute(
            settings: settings, builder: (context) => RootGalaxy());
      },
    );
  }
}

class RootGalaxy extends StatefulWidget {
  @override
  _RootGalaxyState createState() => _RootGalaxyState();
}

class _RootGalaxyState extends State<RootGalaxy>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late ScrollController scrollController;

  double scrollExtent = 0;
  double maxScroll = 200 - kToolbarHeight;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
  }

  scrollListener() {
    setState(() {
      scrollExtent = scrollController.offset;
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BasicRootProvider rootPageProvider =
        Provider.of<BasicRootProvider>(context, listen: false);
    rootPageProvider.pageScrollControllers
        .putIfAbsent(1, () => scrollController);

    double barScale = (maxScroll - scrollExtent) / maxScroll;
    if (barScale < 0) barScale = 0;

    Widget space = SizedBox(height: 8);

    return Scaffold(
      body: NestedScrollViewRefreshIndicator(
        onRefresh: onRefresh,
        child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  elevation: 2,
                  collapsedHeight: 0,
                  toolbarHeight: 0,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Join Challenges\nAnd Earn Points',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                      preferredSize: Size(
                          MediaQuery.of(context).size.width, kToolbarHeight),
                      child: Container(
                        alignment: Alignment.center,
                        height: kToolbarHeight,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: OpenContainer(
                          openElevation: 0.0,
                          closedElevation: 0.0,
                          transitionDuration: Duration(milliseconds: 500),
                          closedColor: Colors.transparent,
                          closedBuilder: (context, open) {
                            return Hero(
                              tag: 'searchPulsar',
                              child: SearchInput(
                                text: 'Search Pulsar',
                                onPressed: open,
                                height: 40 + (barScale * 5),
                              ),
                            );
                          },
                          openBuilder: (context, action) => SearchScreen(),
                        ),
                      )),
                ),
              ];
            },
            body: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              children: [
                space,
                PinnedChallenges(),
                space,
                TrendingChallenges(),
                ChallengesAd(),
                space,
                HighlightChallege(cuisines),
                space,
                DiscoverChallenges(),

                // RecommendedChallenges(),
                // space,
                // // SectionTitle(title: 'Discover'),
              ],
            )),
      ),
    );
  }
}

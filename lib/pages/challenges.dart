// ignore_for_file: unnecessary_const

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
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/refresh_indicator.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({Key? key}) : super(key: key);

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
            settings: settings, builder: (context) => const RootGalaxy());
      },
    );
  }
}

class RootGalaxy extends StatefulWidget {
  const RootGalaxy({Key? key}) : super(key: key);

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

  Map<String, dynamic> data = {};

  bool errorLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
  }

  scrollListener() {
    setState(() {
      scrollExtent = scrollController.offset;
    });
  }

  fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      data = {
        'pinnedChallenges': [],
        'trendingChallenges': [],
        'highlightChallenge': cuisines,
        'discoverChallenges': []
      };
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
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

    Widget space = const SizedBox(height: 8);

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
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Join Challenges\nAnd Earn Points',
                        style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: OpenContainer(
                          openElevation: 0.0,
                          closedElevation: 0.0,
                          transitionDuration: const Duration(milliseconds: 500),
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
                          openBuilder: (context, action) =>
                              const SearchScreen(),
                        ),
                      )),
                ),
              ];
            },
            body: data.isEmpty
                ? errorLoading
                    ? const NetworkError()
                    : const Center(child: MyProgressIndicator())
                : ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    children: [
                      space,
                      const PinnedChallenges(),
                      space,
                      const TrendingChallenges(),
                      const ChallengesAd(),
                      space,
                      HighlightChallege(data['highlightChallenge']),
                      space,
                      const DiscoverChallenges(),

                      // RecommendedChallenges(),
                      // space,
                      // // SectionTitle(title: 'Discover'),
                    ],
                  )),
      ),
    );
  }
}

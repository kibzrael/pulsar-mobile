import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pulsar/ads/my_galaxy_ad.dart';

import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/models/discover_challenges.dart';
import 'package:pulsar/models/highlight_challenge.dart';
import 'package:pulsar/models/pinned_challenges.dart';
import 'package:pulsar/models/trending_challenges.dart';
import 'package:pulsar/my_galaxy/search/search_screen.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/challenges.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/refresh_indicator.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({Key? key}) : super(key: key);

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
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
  State<RootGalaxy> createState() => _RootGalaxyState();
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

  late UserProvider userProvider;

  Challenge? newHighlight;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
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
    try {
      String url = getUrl(ChallengesUrl.myGalaxy);

      http.Response response = await http.get(Uri.parse(url),
          headers: {"Authorization": userProvider.user.token ?? ''});
      var responseData = jsonDecode(response.body);
      if (responseData is Map) {
        data = responseData as Map<String, dynamic>;
        newHighlight = Challenge.fromJson(data['new highlight']);
        setState(() {});
      }
    } catch (e) {
      setState(() {
        errorLoading = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future onRefresh() async {
    await fetchData();
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);

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
                    ? NetworkError(onRetry: onRefresh)
                    : const Center(child: MyProgressIndicator())
                : ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    children: [
                      space,
                      PinnedChallenges(
                          List<Map<String, dynamic>>.from(data['pinned'])),
                      space,
                      if (data['top'].length > 0)
                        TrendingChallenges(
                            List<Map<String, dynamic>>.from(data['top'])),
                      const MyGalaxyAd(),
                      space,
                      if (newHighlight != null)
                        HighlightChallege(newHighlight!),
                      space,
                      DiscoverChallenges(
                          List<Map<String, dynamic>>.from(data['discover'])),

                      // RecommendedChallenges(),
                      // space,
                      // // SectionTitle(title: 'Discover'),
                    ],
                  )),
      ),
    );
  }
}

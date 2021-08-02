import 'package:flutter/material.dart' hide NestedScrollView;

import 'package:animations/animations.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/ads/native_ad.dart';

import 'package:pulsar/basic_root.dart';
import 'package:pulsar/models/discover_challenges.dart';
import 'package:pulsar/models/discover_galaxy.dart';
import 'package:pulsar/models/discover_galaxy_tags.dart';
import 'package:pulsar/models/followed_tags.dart';
import 'package:pulsar/models/pinned_challenges.dart';
import 'package:pulsar/models/recommended_challenges.dart';
import 'package:pulsar/my_galaxy/search/search_screen.dart';
import 'package:pulsar/pages/home_page.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';
import 'package:pulsar/widgets/section.dart';

class MyGalaxy extends StatefulWidget {
  @override
  _MyGalaxyState createState() => _MyGalaxyState();
}

class _MyGalaxyState extends State<MyGalaxy> {
  GlobalKey<NavigatorState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(1, () => key);
    return Scaffold(
      body: Navigator(
        key: key,
        initialRoute: '/',
        observers: [MyRouteObserver(context, 1)],
        onGenerateRoute: (settings) {
          return myPageRoute(
              settings: settings, builder: (context) => RootGalaxy());
        },
      ),
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

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future onRefresh() async {
    Future.delayed(Duration(seconds: 4));
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BasicRootProvider rootPageProvider =
        Provider.of<BasicRootProvider>(context, listen: false);
    rootPageProvider.pageScrollControllers
        .putIfAbsent(1, () => scrollController);

    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
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
                  ),
                );
              },
              openBuilder: (context, action) => SearchScreen(),
            ),
          ),
        ),
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, f) {
            Widget space = SizedBox(
              height: 8,
            );
            return [
              SliverList(
                  delegate: SliverChildListDelegate(
                [
                  FollowedTags(),
                  space,
                  PinnedChallenges(),
                  space,
                  DiscoverChallenges(),
                  MyNativeAd(),
                  RecommendedChallenges(),
                  space,
                  SectionTitle(title: 'Discover'),
                ],
              )),
            ];
          },
          innerScrollPositionKeyBuilder: () {
            return Key('Scroll1');
          },
          body: Column(
            children: [
              DiscoverGalaxyTags(),
              Expanded(
                child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: NestedScrollViewInnerScrollPositionKeyWidget(
                        Key('Scroll1'), DiscoverGalaxy())),
              ),
            ],
          ),
        ));
  }
}

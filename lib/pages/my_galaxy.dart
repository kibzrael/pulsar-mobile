import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/models/discover_challenges.dart';
import 'package:pulsar/models/pinned_challenges.dart';
import 'package:pulsar/models/recommended_challenges.dart';
import 'package:pulsar/my_galaxy/search/search_screen.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';

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

  // double barScrollExtent = 150 - kToolbarHeight;

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

    // double scrollScale = scrollExtent / barScrollExtent;
    // if (scrollScale > 1) scrollScale = 1;

    // double barScale = 0.75 + (scrollScale * 0.25);

    Widget space = SizedBox(
      height: 8,
    );

    // ColorTween iconTween = ColorTween(
    //     begin: Theme.of(context).inputDecorationTheme.hintStyle!.color,
    //     end: Theme.of(context).textTheme.bodyText1!.color);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
          child: OpenContainer(
            openElevation: 0.0,
            closedElevation: 0.0,
            transitionDuration: Duration(milliseconds: 700),
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
      body: RefreshIndicator(
        onRefresh: onRefresh,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: ListView(
          controller: scrollController,
          children: [
            space,
            PinnedChallenges(),
            space,
            DiscoverChallenges(),
            ListTileAd(),
            RecommendedChallenges(),
            space,
            // SectionTitle(title: 'Discover'),
          ],
        ),
      ),
      //     body: RefreshIndicator(
      //   onRefresh: onRefresh,
      //   child: CustomScrollView(
      //     controller: scrollController,
      //     slivers: [
      //       SliverAppBar(
      //         floating: false,
      //         pinned: true,
      //         titleSpacing: 0.0,
      //         expandedHeight: 150,
      //         stretch: true,
      //         flexibleSpace: FlexibleSpaceBar(
      //           // titlePadding:
      //           //     EdgeInsetsDirectional.only(start: 15, bottom: 12.5, end: 0),
      //           titlePadding: EdgeInsets.zero,
      //           collapseMode: CollapseMode.pin,
      //           title: Container(
      //             height: double.infinity,
      //             child: Stack(
      //               children: [
      //                 Positioned(
      //                   bottom: 50 - (scrollScale * 42.5),
      //                   left: 15 + (scrollScale * 15),
      //                   child: Text(
      //                     'My Galaxy',
      //                     maxLines: 1,
      //                     style: TextStyle(fontSize: 32),
      //                   ),
      //                 ),
      //                 Positioned(
      //                   bottom: 0,
      //                   right: scrollScale * 15,
      //                   left: (scrollScale *
      //                       (MediaQuery.of(context).size.width - (15 + 37.5))),
      //                   child: InkWell(
      //                     onTap: () {
      //                       print('Hey search');
      //                     },
      //                     child: Transform.scale(
      //                       scale: barScale,
      //                       alignment: Alignment.center,
      //                       child: Container(
      //                         // height: 30 + (scrollScale * 7.5),
      //                         width: 37.5 +
      //                             (1 - scrollScale) *
      //                                 (MediaQuery.of(context).size.width *
      //                                     barScale),
      //                         height: 37.5,
      //                         margin: EdgeInsets.only(bottom: 8),
      //                         padding: EdgeInsets.symmetric(
      //                             horizontal: (1 - scrollScale) * 15,
      //                             vertical: 4),
      //                         alignment: Alignment.center,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(30),
      //                           color: Theme.of(context)
      //                               .inputDecorationTheme
      //                               .fillColor!
      //                               .withOpacity(1 - scrollScale),
      //                         ),
      //                         child: Container(
      //                           width: 37.7 + (1 - scrollScale) * 200,
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Icon(
      //                                 MyIcons.search,
      //                                 color: iconTween.transform(scrollScale),
      //                               ),
      //                               if (scrollScale < 1)
      //                                 Flexible(
      //                                   child: Container(
      //                                     margin: EdgeInsets.only(
      //                                         left: (1 - scrollScale) * 15),
      //                                     child: Text(
      //                                       'Search Pulsar',
      //                                       style: Theme.of(context)
      //                                           .inputDecorationTheme
      //                                           .hintStyle,
      //                                       softWrap: false,
      //                                       maxLines: 1,
      //                                     ),
      //                                   ),
      //                                 )
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       SliverList(
      //         delegate: SliverChildListDelegate([
      //           FollowedTags(),
      //           space,
      //           PinnedChallenges(),
      //           space,
      //           DiscoverChallenges(),
      //           ListTileAd(),
      //           RecommendedChallenges(),
      //         ]),
      //       ),
      //       SliverPadding(
      //           padding: EdgeInsets.only(
      //               bottom: MediaQuery.of(context).padding.bottom))
      //     ],
      //   ),
      // )

      // RefreshIndicator(
      //   onRefresh: onRefresh,
      //   triggerMode: RefreshIndicatorTriggerMode.anywhere,
      //   child: ListView(
      //     controller: scrollController,
      //     children: [
      //       FollowedTags(),
      //       space,
      //       PinnedChallenges(),
      //       space,
      //       DiscoverChallenges(),
      //       ListTileAd(),
      //       RecommendedChallenges(),
      //       space,
      //       // SectionTitle(title: 'Discover'),
      //     ],
      //   ),
      // )

      // NestedScrollViewRefreshIndicator(
      //   onRefresh: onRefresh,
      //   child: ExtendedNestedScrollView(
      //     controller: scrollController,
      //     headerSliverBuilder: (context, f) {
      //       Widget space = SizedBox(
      //         height: 8,
      //       );
      //       return [
      //         SliverList(
      //             delegate: SliverChildListDelegate(
      //           [
      //             FollowedTags(),
      //             space,
      //             PinnedChallenges(),
      //             space,
      //             DiscoverChallenges(),
      //             ListTileAd(),
      //             RecommendedChallenges(),
      //             space,
      //             SectionTitle(title: 'Discover'),
      //           ],
      //         )),
      //       ];
      //     },
      //     // innerScrollPositionKeyBuilder: () {
      //     //   return Key('Scroll1');
      //     // },
      //     // onlyOneScrollInBody: true,
      //     // body: Column(
      //     //   children: [
      //     //     DiscoverGalaxyTags(
      //     //       selected: 'For you',
      //     //       onChanged: (_) {},
      //     //     ),
      //     //     Expanded(
      //     //       child: Container(
      //     //           color: Theme.of(context).colorScheme.surface,
      //     //           child: DiscoverGalaxy()),
      //     //     ),
      //     //   ],
      //     // ),
      //   ),
      // )
    );
  }
}

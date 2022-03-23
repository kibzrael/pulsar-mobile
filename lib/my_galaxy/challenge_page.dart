import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:pulsar/ads/list_tile_ad.dart';

import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/models/follow_layout.dart';
import 'package:pulsar/models/profile_stats.dart';
import 'package:pulsar/my_galaxy/leaderboard.dart';
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
  const ChallengePage(this.challenge, {Key? key}) : super(key: key);
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  ScrollController? scrollController;

  double scrollPosition = 0;

  bool isFollowing = false;

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
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      double expandedHeight = constraints.maxHeight > 1024
          ? 300
          : constraints.maxHeight > 720
              ? 250
              : 200;

      return NestedScrollViewRefreshIndicator(
        onRefresh: onRefresh,
        child: ExtendedNestedScrollView(
          // floatHeaderSlivers: true,
          controller: scrollController,
          pinnedHeaderSliverHeightBuilder: () {
            return kToolbarHeight + MediaQuery.of(context).padding.top;
          },
          headerSliverBuilder: (context, bool _) {
            double opacity = scrollPosition / (expandedHeight - kToolbarHeight);
            double padding = scrollPosition > 45 ? 45 : scrollPosition;
            return [
              Theme(
                data: Theme.of(context).brightness == Brightness.dark
                    ? darkTheme
                    : scrollPosition < 130
                        ? darkTheme
                        : lightTheme,
                child: Builder(builder: (context) {
                  return SliverAppBar(
                    floating: false,
                    titleSpacing: 0.0,
                    elevation: 0.0,
                    pinned: true,
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(opacity < 1 ? opacity : 1),
                    expandedHeight: expandedHeight,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_horiz),
                        iconSize: 30,
                        onPressed: moreOnChallenge,
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsetsDirectional.only(
                          start: 56, bottom: 17.5, end: padding),
                      title: Text(
                        challenge.name,
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
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          challenge.cover.photo(context)),
                                      fit: BoxFit.cover)),
                            ),
                          )),
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
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
                  );
                }),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: ListTileAd(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProfileStats(
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
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.ease);
                          },
                          posts: 620000,
                        ),
                      ],
                    ),
                  ),
                  if (challenge.description != '')
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
                      child: Text(
                        challenge.description ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  FollowLayout(
                      middle: Icon(MyIcons.insights),
                      onMiddlePressed: () {
                        Navigator.of(context).push(myPageRoute(
                            builder: (context) => Leaderboard(challenge)));
                      },
                      child: const Text(
                        'Join',
                        style: TextStyle(
                            //color: Theme.of(context).buttonColor,
                            fontWeight: FontWeight.w600),
                      ),
                      isFollowing: isFollowing,
                      isPin: true,
                      onChildPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                            myPageRoute(
                                builder: (context) =>
                                    PostProcess(challenge: challenge)));
                      },
                      onFollow: () {
                        setState(() {
                          challenge.pin(context,
                              mode: challenge.isPinned
                                  ? RequestMethod.delete
                                  : RequestMethod.post);
                          isFollowing = !isFollowing;
                        });
                      }),
                  const SizedBox(height: 3)
                ],
              ))
            ];
          },
          onlyOneScrollInBody: false,
          body: Column(
            children: [
              TabBar(
                controller: tabController,
                indicator: const BoxDecoration(),
                unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
                labelPadding: EdgeInsets.zero,
                tabs: const <Widget>[
                  CustomTab('Recent'),
                  CustomTab(
                    'Trending',
                    divider: false,
                  )
                ],
              ),
              SizedBox(
                height: constraints.maxHeight -
                    (MediaQuery.of(context).padding.top +
                        kToolbarHeight +
                        kTextTabBarHeight),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  constraints: const BoxConstraints(minHeight: 100),
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
      );
    }));
  }
}

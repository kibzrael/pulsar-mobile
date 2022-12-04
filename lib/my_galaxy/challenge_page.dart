import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/ads/list_tile_ad.dart';

import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/models/follow_layout.dart';
import 'package:pulsar/models/profile_stats.dart';
import 'package:pulsar/my_galaxy/leaderboard.dart';
import 'package:pulsar/options/challenge_options.dart';
import 'package:pulsar/post/post_screen.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/interaction_screen.dart';
import 'package:pulsar/secondary_pages.dart/grid_posts.dart';
import 'package:pulsar/urls/challenge.dart';
import 'package:pulsar/urls/get_url.dart';
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

  late InteractionsSync interactionsSync;

  late UserProvider userProvider;

  double scrollPosition = 0;

  bool get isPinned => interactionsSync.isPinned(challenge);

  late Challenge challenge;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    tabController = TabController(length: 2, vsync: this);
    scrollController = ScrollController();
    scrollController!.addListener(scrollListener);
    challenge = widget.challenge;
    fetchChallenge();
  }

  fetchChallenge() async {
    String url = getUrl(ChallengeUrls.challenge(challenge));
    Uri uri = Uri.parse(url);
    http.Response response = await http
        .get(uri, headers: {'Authorization': userProvider.user.token ?? ''});
    try {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        challenge = Challenge.fromJson(data['challenge']);
        setState(() {});
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
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
    await fetchChallenge();
    return true;
  }

  Future<List<Map<String, dynamic>>> fetchPosts(int index, page) async {
    List<Map<String, dynamic>> _posts = [];

    String url = getUrl(ChallengeUrls.posts(challenge, page, index));

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': userProvider.user.token ?? ''});

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _posts = [...List<Map<String, dynamic>>.from(body['posts'])];
    } else {
      Fluttertoast.showToast(msg: body['message']);
    }
    return _posts;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    interactionsSync = Provider.of<InteractionsSync>(context);

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
                        icon: Icon(MyIcons.more),
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
                          pins: challenge.pins,
                          pinsOnPressed: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) => InteractionScreen(
                                      challenge: challenge,
                                      value: challenge.pins,
                                    )));
                          },
                          postOnPressed: () {
                            scrollController!.animateTo(
                                scrollController!.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.ease);
                          },
                          posts: challenge.posts,
                        ),
                      ],
                    ),
                  ),
                  if (!['', null].contains(challenge.description))
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
                      child: challenge.isJoined
                          ? Icon(MyIcons.insights)
                          : const Text(
                              'Join',
                              style: TextStyle(
                                  //color: Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.w600),
                            ),
                      isFollowing: isPinned,
                      isPin: true,
                      onChildPressed: challenge.isJoined
                          ? () {
                              Navigator.of(context).push(myPageRoute(
                                  builder: (context) =>
                                      Leaderboard(challenge)));
                            }
                          : () {
                              Navigator.of(context, rootNavigator: true).push(
                                  myPageRoute(
                                      builder: (context) =>
                                          PostProcess(challenge: challenge)));
                            },
                      onFollow: () {
                        setState(() {
                          challenge.pin(context,
                              mode: isPinned
                                  ? RequestMethod.delete
                                  : RequestMethod.post,
                              onNotify: () => setState(() {}));
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
                      GridPosts(
                        (index) async {
                          return await fetchPosts(index, 0);
                        },
                        title: '#${challenge.name}',
                      ),
                      GridPosts(
                        (index) async {
                          return await fetchPosts(index, 0);
                        },
                        title: '#${challenge.name}',
                      ),
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

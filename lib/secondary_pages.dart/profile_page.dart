import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/models/follow_layout.dart';
import 'package:pulsar/models/profile.dart';
import 'package:pulsar/options/user_options.dart';
import 'package:pulsar/pages/my_profile.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/grid_posts.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/refresh_indicator.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage(this.user, {Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? tabController;
  ScrollController? scrollController;

  late UserProvider userProvider;

  late User user;

  late InteractionsSync interactionsSync;

  bool get isFollowing => interactionsSync.isFollowing(user);

  @override
  bool get wantKeepAlive => true;

  bool refreshing = false;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(tabControlerListener);
    scrollController = ScrollController();
    user = widget.user;
    if (!user.profileIsComplete) {
      user.getProfile(context, () {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController!.removeListener(tabControlerListener);
    tabController!.dispose();
    scrollController!.dispose();
    super.dispose();
  }

  int index = 0;
  void tabControlerListener() {
    if (index != tabController!.index) {
      index = tabController!.index;
    }
  }

  Future<bool> onRefresh() async {
    await user.getProfile(context, () {
      refreshing = true;
      if (mounted) {
        setState(() {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            refreshing = false;
            if (mounted) setState(() {});
          });
        });
      }
    });
    return true;
  }

  moreOnUser() {
    openBottomSheet(context, (context) => UserOptions(user));
  }

  Future<List<Map<String, dynamic>>> fetchPosts(int index, int page) async {
    List<Map<String, dynamic>> results = [];

    String url = getUrl(UserUrls.posts(user.id, page, index));

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': userProvider.user.token ?? ''});

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      results = [...List<Map<String, dynamic>>.from(body['posts'])];
    } else {
      Fluttertoast.showToast(msg: body['message']);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);
    interactionsSync = Provider.of<InteractionsSync>(context);
    bool isMyProfile = userProvider.user.id == user.id;
    return isMyProfile
        ? const RootProfilePage()
        : Scaffold(
            appBar: AppBar(
              title: Text('@${user.username}'),
              actions: [
                IconButton(icon: Icon(MyIcons.more), onPressed: moreOnUser)
              ],
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              return NestedScrollViewRefreshIndicator(
                onRefresh: onRefresh,
                child: ExtendedNestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder: (BuildContext context, bool? f) {
                      return [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Profile(
                                user,
                                scrollController: scrollController!,
                              ),
                              FollowLayout(
                                  middle: const Image(
                                    image: AssetImage(
                                        'assets/images/logos/instagram.png'),
                                    width: 24,
                                  ),
                                  isFollowing: isFollowing,
                                  onMiddlePressed: () {
                                    toastNotImplemented();
                                  },
                                  onChildPressed: () {
                                    toastNotImplemented();
                                    // Navigator.of(context, rootNavigator: true).push(
                                    //     myPageRoute(
                                    //         builder: (context) => MessagingScreen(
                                    //             Chat([user, tahlia]))));
                                  },
                                  onFollow: () {
                                    setState(() {
                                      user.follow(context,
                                          mode: isFollowing
                                              ? RequestMethod.delete
                                              : RequestMethod.post,
                                          onNotify: () => setState(() {}));
                                    });
                                  },
                                  child: Icon(
                                    MyIcons.send,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ))
                            ],
                          ),
                        ),
                      ];
                    },
                    onlyOneScrollInBody: false,
                    body: Column(
                      children: <Widget>[
                        TabBar(
                          controller: tabController,
                          indicator: const BoxDecoration(),
                          labelPadding: EdgeInsets.zero,
                          unselectedLabelColor:
                              Theme.of(context).unselectedWidgetColor,
                          tabs: <Widget>[
                            CustomTab(
                              'Posts',
                              icon: MyIcons.posts,
                            ),
                            CustomTab(
                              'Reposts',
                              icon: MyIcons.repost,
                              divider: false,
                            )
                          ],
                        ),
                        SizedBox(
                          height: constraints.maxHeight - kTextTabBarHeight,
                          child: Container(
                            color: Theme.of(context).colorScheme.surface,
                            constraints: const BoxConstraints(minHeight: 100),
                            child: TabBarView(
                              controller: tabController,
                              children: <Widget>[
                                GridPosts(
                                  (index) async {
                                    return await fetchPosts(index, 0);
                                  },
                                  title: '@${user.username}',
                                  refreshing: refreshing,
                                ),
                                GridPosts(
                                  (index) async {
                                    return await fetchPosts(index, 1);
                                  },
                                  title: '@${user.username}',
                                  refreshing: refreshing,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              );
            }),
          );
  }
}

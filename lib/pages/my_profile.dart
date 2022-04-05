import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/models/profile.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/promotion/promote.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/edit_profile.dart';
import 'package:pulsar/secondary_pages.dart/grid_posts.dart';
import 'package:pulsar/settings/settings_page.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/refresh_indicator.dart';
import 'package:pulsar/widgets/route.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  GlobalKey<NavigatorState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(4, () => key);
    return Navigator(
      key: key,
      initialRoute: '/',
      observers: [MyRouteObserver(context, 4)],
      onGenerateRoute: (settings) {
        return myPageRoute(
            settings: settings, builder: (context) => const RootProfilePage());
      },
    );
  }
}

class RootProfilePage extends StatefulWidget {
  const RootProfilePage({Key? key}) : super(key: key);

  @override
  _RootProfilePageState createState() => _RootProfilePageState();
}

class _RootProfilePageState extends State<RootProfilePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? tabController;
  late ScrollController scrollController;

  late UserProvider provider;

  late User user;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(tabControlerListener);
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    tabController!.removeListener(tabControlerListener);
    tabController!.dispose();
    scrollController.dispose();
    super.dispose();
  }

  int index = 0;
  void tabControlerListener() {
    if (index != tabController!.index) {
      setState(() {
        index = tabController!.index;
      });
    }
  }

  Future<bool> onRefresh() async {
    await user.getProfile(context, () {
      if (mounted) setState(() {});
    });
    provider.notify();
    return true;
  }

  Future<List<Map<String, dynamic>>> fetchPosts(int index, int page) async {
    List<Map<String, dynamic>> _posts = [];

    String url = getUrl(UserUrls.posts(user.id, page, index));

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': provider.user.token ?? ''});

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
    super.build(context);

    provider = Provider.of<UserProvider>(context);
    user = provider.user;

    BasicRootProvider rootPageProvider =
        Provider.of<BasicRootProvider>(context, listen: false);
    rootPageProvider.pageScrollControllers
        .update(4, (_) => scrollController, ifAbsent: () => scrollController);
    return Scaffold(
      appBar: AppBar(
        title: Text('@${user.username}'),
        actions: [
          IconButton(
              icon: Icon(MyIcons.tune),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    myPageRoute(builder: (context) => const SettingsPage()));
              })
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
                          scrollController: scrollController,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 45),
                          // constraints: const BoxConstraints(maxWidth: 480),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: ActionButton(
                                  title: 'Edit Profile',
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        myPageRoute(
                                            builder: (context) =>
                                                const EditProfile()));
                                    user.getProfile(context, () {
                                      if (mounted) setState(() {});
                                    });
                                  },
                                  height: 37.5,
                                ),
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(myPageRoute(
                                      builder: (context) => const Promote()));
                                },
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.zero,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Container(
                                    child: const Text(
                                      'Promote',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    height: 35,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              // innerScrollPositionKeyBuilder: () {
              //   String index = 'Tab';
              //   index += tabController!.index.toString();
              //   return Key(index);
              // },
              onlyOneScrollInBody: false,
              body: SizedBox(
                height: constraints.maxHeight,
                child: Column(
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
                        child: TabBarView(
                          controller: tabController,
                          children: <Widget>[
                            GridPosts(
                              (index) async {
                                return await fetchPosts(index, 0);
                              },
                              title: '@${user.username}',
                            ),
                            GridPosts(
                              (index) async {
                                return await fetchPosts(index, 1);
                              },
                              title: '@${user.username}',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        );
      }),
    );
  }
}

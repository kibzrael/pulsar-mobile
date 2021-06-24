import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/models/profile.dart';
import 'package:pulsar/secondary_pages.dart/edit_profile.dart';
import 'package:pulsar/secondary_pages.dart/grid_posts.dart';
import 'package:pulsar/settings/settings_page.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/route.dart';

class MyProfilePage extends StatefulWidget {
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
    return Scaffold(
      body: Navigator(
        key: key,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return myPageRoute(
              settings: settings, builder: (context) => RootProfilePage());
        },
      ),
    );
  }
}

class RootProfilePage extends StatefulWidget {
  @override
  _RootProfilePageState createState() => _RootProfilePageState();
}

class _RootProfilePageState extends State<RootProfilePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? tabController;
  late ScrollController scrollController;

  late User user;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(tabControlerListener);
    scrollController = ScrollController();

    user = tahlia;
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
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BasicRootProvider rootPageProvider =
        Provider.of<BasicRootProvider>(context, listen: false);
    rootPageProvider.pageScrollControllers
        .putIfAbsent(4, () => scrollController);
    return Scaffold(
      appBar: AppBar(
        title: Text('@${user.username}'),
        actions: [
          IconButton(
              icon: Icon(MyIcons.tune),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .push(myPageRoute(builder: (context) => SettingsPage()));
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: NestedScrollView(
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
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 45),
                          child: ActionButton(
                            title: 'Edit Profile',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  myPageRoute(
                                      builder: (context) => EditProfile()));
                            },
                            height: 42,
                          )),
                    ],
                  ),
                ),
              ];
            },
            innerScrollPositionKeyBuilder: () {
              String index = 'Tab';
              index += tabController!.index.toString();
              return Key(index);
            },
            body: Column(
              children: <Widget>[
                TabBar(
                  controller: tabController,
                  indicator: BoxDecoration(),
                  labelPadding: EdgeInsets.zero,
                  unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
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
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        NestedScrollViewInnerScrollPositionKeyWidget(
                          Key('Tab0'),
                          GridPosts(user),
                        ),
                        NestedScrollViewInnerScrollPositionKeyWidget(
                            Key('Tab1'), GridPosts(user)),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

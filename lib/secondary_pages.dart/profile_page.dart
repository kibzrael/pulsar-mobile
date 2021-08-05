import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:pulsar/classes/chat.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/messaging/messaging_screen.dart';
import 'package:pulsar/models/follow_layout.dart';
import 'package:pulsar/models/profile.dart';
import 'package:pulsar/options/user_options.dart';
import 'package:pulsar/secondary_pages.dart/grid_posts.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/route.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage(this.user);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? tabController;
  ScrollController? scrollController;

  bool isFollowed = false;

  late User user;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(tabControlerListener);
    scrollController = ScrollController();

    user = widget.user;
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
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  moreOnUser() {
    openBottomSheet(context, (context) => UserOptions(user));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('@${user.username}'),
        actions: [IconButton(icon: Icon(MyIcons.more), onPressed: moreOnUser)],
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
                        scrollController: scrollController!,
                      ),
                      FollowLayout(
                          child: Icon(
                            MyIcons.send,
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                          isFollowed: isFollowed,
                          onChildPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                                myPageRoute(
                                    builder: (context) =>
                                        MessagingScreen(Chat([user, tahlia]))));
                          },
                          onFollow: () {
                            setState(() {
                              isFollowed = !isFollowed;
                            });
                          })
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
                    constraints: BoxConstraints(minHeight: 100),
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

import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/models/follow_layout.dart';
import 'package:pulsar/post/post_screen.dart';
import 'package:pulsar/secondary_pages.dart/photo_view.dart';
import 'package:pulsar/secondary_pages.dart/grid_posts.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class TagPage extends StatefulWidget {
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? tabController;
  ScrollController? scrollController;

  bool isFollowed = false;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('#Tag'), actions: [
        IconButton(
          icon: Icon(MyIcons.more),
          onPressed: () {},
        )
      ]),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (BuildContext context, bool? f) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (context) => PhotoView(
                                                'assets/users/rael.jpg',
                                                tag: 'tagPic')));
                                  },
                                  child: Hero(
                                    tag: 'tagPic',
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).dividerColor,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/users/rael.jpg'),
                                              fit: BoxFit.cover)),
                                    ),
                                  )

                                  // MyAvatar(user.tagPic, 45.0)
                                  ),
                            ),
                            Text(
                              '#Tag',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 21),
                            ),
                            SizedBox(height: 1.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MyIcons.play,
                                  size: 21,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .color,
                                ),
                                Text(
                                  '2.7M posts',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            FollowLayout(
                                child: Text(
                                  'Post',
                                ),
                                isFollowed: isFollowed,
                                onChildPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) => PostProcess()));
                                },
                                onFollow: () {
                                  setState(() {
                                    isFollowed = !isFollowed;
                                  });
                                })
                          ],
                        ),
                      ),
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
                      'Recent',
                    ),
                    CustomTab(
                      'Trending',
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
                          GridPosts(evanna),
                        ),
                        NestedScrollViewInnerScrollPositionKeyWidget(
                            Key('Tab1'), GridPosts(evanna)),
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

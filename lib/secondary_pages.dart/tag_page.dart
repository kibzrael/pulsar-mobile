import 'dart:convert';

import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/options/tag_options.dart';
import 'package:pulsar/post/post_screen.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/secondary_pages.dart/grid_posts.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/post.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:pulsar/widgets/refresh_indicator.dart';
import 'package:pulsar/widgets/route.dart';

class TagPage extends StatefulWidget {
  final String tag;
  const TagPage(this.tag, {Key? key}) : super(key: key);

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? tabController;
  ScrollController? scrollController;

  late String tag;

  late UserProvider userProvider;
  int count = 0;

  @override
  bool get wantKeepAlive => true;

  bool refreshing = false;

  @override
  void initState() {
    tag = widget.tag;
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

  moreOnTag() {
    openBottomSheet(context, (context) => TagOptions(tag));
  }

  Future<List<Map<String, dynamic>>> fetchPosts(int index, int page) async {
    List<Map<String, dynamic>> results = [];

    String url = getUrl(PostUrls.tag(tag, index, page));

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': userProvider.user.token ?? ''});

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      count = body['count'];
      setState(() {});
      results = [...List<Map<String, dynamic>>.from(body['posts'])];
    } else {
      Fluttertoast.showToast(msg: body['message']);
    }
    return results;
  }

  Future<bool> onRefresh() async {
    refreshing = true;
    if (mounted) {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          refreshing = false;
          if (mounted) setState(() {});
        });
      });
    }
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('#$tag'), actions: [
        IconButton(
          icon: Icon(MyIcons.more),
          onPressed: moreOnTag,
        )
      ]),
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
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MyIcons.play,
                                  size: 21,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color,
                                ),
                                Text(
                                  '$count post${count == 1 ? '' : 's'}',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 18),
                                ),
                                const SizedBox(width: 30),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(myPageRoute(
                                            builder: (context) =>
                                                PostProcess(tag: tag)));
                                  },
                                  child: Card(
                                    elevation: 4,
                                    margin: EdgeInsets.zero,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Container(
                                      height: 35,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      child: const Text(
                                        'Post',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
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
              body: Column(
                children: <Widget>[
                  TabBar(
                    controller: tabController,
                    indicator: const BoxDecoration(),
                    labelPadding: EdgeInsets.zero,
                    unselectedLabelColor:
                        Theme.of(context).unselectedWidgetColor,
                    tabs: const <Widget>[
                      CustomTab(
                        'Recent',
                      ),
                      CustomTab(
                        'Trending',
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
                        children: [
                          GridPosts(
                            (index) async {
                              return await fetchPosts(index, 0);
                            },
                            title: '#$tag',
                            refreshing: refreshing,
                          ),
                          GridPosts(
                            (index) async {
                              return await fetchPosts(index, 1);
                            },
                            title: '#$tag',
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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/models/posts_view.dart';
import 'package:pulsar/notifications/notifications_page.dart';
import 'package:pulsar/options/post_options.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/route.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<NavigatorState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(0, () => key);
    return Scaffold(
        body: Navigator(
      key: key,
      initialRoute: '/',
      observers: [MyRouteObserver(context, 0)],
      onGenerateRoute: (settings) {
        return myPageRoute(
            settings: settings, builder: (context) => RootHomePage());
      },
    ));
  }
}

class RootHomePage extends StatefulWidget {
  @override
  _RootHomePageState createState() => _RootHomePageState();
}

class _RootHomePageState extends State<RootHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late CarouselController pageController;

  int pageIndex = 0;

  List<Post> posts = allPosts;

  @override
  void initState() {
    super.initState();
    posts.shuffle();
    pageController = CarouselController();
  }

  void onPageChanged(int? index) {
    setState(() {
      pageIndex = index ?? 0;
    });
  }

  void openNotifications() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => NotificationsPage()));
  }

  void moreOnPost() {
    openBottomSheet(context, (context) => PostOptions(lynn1));
  }

  Widget segmentObject(String text, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => onPageChanged(index),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            alignment:
                index == 0 ? Alignment.centerRight : Alignment.centerLeft,
            height: 37.5 - 4,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                maxLines: 1,
                style: TextStyle(
                    color: pageIndex == index ? Colors.white : Colors.white70,
                    fontWeight:
                        pageIndex == index ? FontWeight.w800 : FontWeight.w600,
                    fontSize: pageIndex == index ? 18.5 : 16.5),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BasicRootProvider rootPageProvider =
        Provider.of<BasicRootProvider>(context, listen: false);

    rootPageProvider.pageScrollControllers.putIfAbsent(0, () => pageController);

    return Theme(
      data: darkTheme,
      child: Builder(builder: (
        context,
      ) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              titleSpacing: 0.0,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(MyIcons.notifications),
                onPressed: openNotifications,
              ),
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    segmentObject('Following', 0),
                    Container(
                      width: 0.75,
                      height: 12,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      color: Colors.white54,
                    ),
                    segmentObject('Discover', 1)
                  ],
                ),
              ),
              actions: [
                IconButton(icon: Icon(MyIcons.more), onPressed: moreOnPost)
              ],
            ),
            body: PostsView(initialPosts: posts, controller: pageController));
      }),
    );
  }
}

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  BuildContext context;
  int index;

  MyRouteObserver(this.context, this.index);

  void _sendScreenView(PageRoute<dynamic> route) {
    String? screenName = route.settings.name;
    BasicRootProvider provider =
        Provider.of<BasicRootProvider>(context, listen: false);
    provider.navigatorsTop.update(index, (value) => '$screenName');
    provider.notify();
    print('${provider.navigatorsTop}');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
